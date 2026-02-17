import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/services/auth_service.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:hachimi_app/services/firestore_service.dart';

/// Service providers — singletons
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());
final analyticsServiceProvider =
    Provider<AnalyticsService>((ref) => AnalyticsService());

/// Auth state — SSOT for current user authentication.
/// Streams from Firebase Auth state changes.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Current user UID — convenience provider
final currentUidProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).value?.uid;
});
