import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/app.dart';
import 'package:hachimi_app/services/auth_service.dart';
import 'package:hachimi_app/services/focus_timer_service.dart';
import 'package:hachimi_app/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Initialize Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Initialize Google Sign-In (must be after Firebase.initializeApp)
  await AuthService().initializeGoogleSignIn();

  // Initialize foreground task for focus timer
  FocusTimerService.init();

  // Initialize notification plugins and channels (no permission request)
  await NotificationService().initializePlugins();

  runApp(
    const ProviderScope(
      child: HachimiApp(),
    ),
  );
}
