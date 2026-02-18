import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity stream — SSOT for device network interface status.
/// Maps ConnectivityResult to a simple bool (true = connected).
final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    return results.any((r) => r != ConnectivityResult.none);
  });
});

/// Simple offline flag for UI — true when device has no network interface.
/// Defaults to false (online) during initial loading.
final isOfflineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (isConnected) => !isConnected,
    loading: () => false,
    error: (_, __) => false,
  );
});
