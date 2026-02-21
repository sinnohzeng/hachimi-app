import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/app.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/services/auth_service.dart';
import 'package:hachimi_app/services/focus_timer_service.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configure Firestore offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Crashlytics: only collect in release builds
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(kReleaseMode);

    // Capture Flutter framework errors
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Capture async errors not caught by Flutter framework
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Initialize Google Sign-In (must be after Firebase.initializeApp)
    await AuthService().initializeGoogleSignIn();

    // Initialize foreground task for focus timer
    FocusTimerService.init();

    // Initialize notification plugins and channels (no permission request)
    await NotificationService().initializePlugins();
  } catch (e, stack) {
    debugPrint('[main] initialization failed: $e');
    ErrorHandler.record(
      e,
      stackTrace: stack,
      source: 'main',
      operation: 'initialization',
      fatal: true,
    );
    runApp(_InitErrorApp(error: e.toString()));
    return;
  }

  runApp(const ProviderScope(child: HachimiApp()));
}

/// 初始化失败时显示的错误页面。
class _InitErrorApp extends StatelessWidget {
  final String error;
  const _InitErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(error, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
