import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStateResolver {
  NetworkStateResolver._();

  static final Connectivity _connectivity = Connectivity();

  static Future<String> resolve() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return 'offline';
    }
    if (results.contains(ConnectivityResult.wifi)) return 'wifi';
    if (results.contains(ConnectivityResult.mobile)) return 'mobile';
    if (results.contains(ConnectivityResult.ethernet)) return 'ethernet';
    if (results.contains(ConnectivityResult.vpn)) return 'vpn';
    if (results.contains(ConnectivityResult.bluetooth)) return 'bluetooth';
    if (results.contains(ConnectivityResult.other)) return 'other';
    return 'unknown';
  }
}
