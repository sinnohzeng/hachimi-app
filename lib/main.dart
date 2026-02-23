import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/app.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'firebase_options.dart';

void main() async {
  // [R6] 冷启动性能度量
  final startupStopwatch = Stopwatch()..start();

  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Firebase + SharedPreferences 并行初始化（关键路径）
    final results = await Future.wait([
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      SharedPreferences.getInstance(),
    ]);

    final prefs = results[1] as SharedPreferences;

    // Configure Firestore offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Crashlytics: only collect in release builds
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      kReleaseMode,
    );

    // Capture Flutter framework errors
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Capture async errors not caught by Flutter framework
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    debugPrint(
      '[STARTUP] critical init: ${startupStopwatch.elapsedMilliseconds}ms',
    );

    // 注册 Pixel Cat Sprites 的 CC BY-NC 4.0 许可证归属
    LicenseRegistry.addLicense(() async* {
      yield const LicenseEntryWithLineBreaks(
        ['Pixel Cat Sprites'],
        'Pixel Cat Sprites by pixel-cat-maker\n'
        'Licensed under Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)\n'
        'https://creativecommons.org/licenses/by-nc/4.0/',
      );
    });

    // 非关键初始化（GoogleSignIn、通知、FocusTimer）延迟到首帧后执行
    // 参见 DeferredInit
    runApp(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: HachimiApp(startupStopwatch: startupStopwatch),
      ),
    );
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
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                  semanticLabel: 'Error',
                ),
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
