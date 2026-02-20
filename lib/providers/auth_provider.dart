import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/services/auth_service.dart';

// Re-export service_providers so existing imports continue to work.
export 'package:hachimi_app/providers/service_providers.dart';

/// Auth service — singleton
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Auth state — SSOT for current user authentication.
/// Streams from Firebase Auth state changes.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Current user UID — convenience provider
final currentUidProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).value?.uid;
});
