import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/app.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/observability/observability_runtime.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  final startupStopwatch = Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final prefs = await _initializeCriticalServices();
    _registerLicenseAttribution();
    _runMainApp(startupStopwatch, prefs);
  } catch (e, stack) {
    _handleInitFailure(e, stack);
  }
}

Future<SharedPreferences> _initializeCriticalServices() async {
  final results = await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    SharedPreferences.getInstance(),
  ]);
  await _activateAppCheck();
  final prefs = results[1] as SharedPreferences;
  await ObservabilityRuntime.initialize();
  final cachedUid = prefs.getString(AppPrefsKeys.cachedUid);
  if (cachedUid != null && cachedUid.isNotEmpty) {
    ObservabilityRuntime.setUidHashFromUid(cachedUid);
  }

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await _configureCrashlytics();
  return prefs;
}

Future<void> _activateAppCheck() async {
  await FirebaseAppCheck.instance.activate(
    providerAndroid: kReleaseMode
        ? const AndroidPlayIntegrityProvider()
        : const AndroidDebugProvider(),
    providerApple: kReleaseMode
        ? const AppleAppAttestWithDeviceCheckFallbackProvider()
        : const AppleDebugProvider(),
  );
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
}

Future<void> _configureCrashlytics() async {
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    kReleaseMode,
  );
  FlutterError.onError = _handleFlutterFatal;
  PlatformDispatcher.instance.onError = (error, stack) {
    _handlePlatformFatal(error, stack);
    return true;
  };
}

void _handleFlutterFatal(FlutterErrorDetails details) {
  unawaited(
    ErrorHandler.recordOperation(
      details.exception,
      stackTrace: details.stack,
      feature: 'FlutterFramework',
      operation: 'onError',
      operationStage: 'bootstrap',
      fatal: true,
      errorCode: 'flutter_fatal',
    ),
  );
}

void _handlePlatformFatal(Object error, StackTrace stack) {
  unawaited(
    ErrorHandler.recordOperation(
      error,
      stackTrace: stack,
      feature: 'PlatformDispatcher',
      operation: 'onError',
      operationStage: 'bootstrap',
      fatal: true,
      errorCode: 'platform_fatal',
    ),
  );
}

void _registerLicenseAttribution() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(
      ['Pixel Cat Sprites'],
      'Pixel Cat Sprites by pixel-cat-maker\n'
      'Licensed under Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)\n'
      'https://creativecommons.org/licenses/by-nc/4.0/',
    );
  });
}

void _runMainApp(Stopwatch startupStopwatch, SharedPreferences prefs) {
  debugPrint(
    '[STARTUP] critical init: ${startupStopwatch.elapsedMilliseconds}ms',
  );
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: HachimiApp(startupStopwatch: startupStopwatch),
    ),
  );
}

void _handleInitFailure(Object error, StackTrace stack) {
  debugPrint('[main] initialization failed: $error');
  ErrorHandler.recordOperation(
    error,
    stackTrace: stack,
    feature: 'main',
    operation: 'initialization',
    fatal: true,
  );
  runApp(_InitErrorApp(error: error.toString()));
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
