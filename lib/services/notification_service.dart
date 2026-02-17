import 'package:firebase_messaging/firebase_messaging.dart';

/// NotificationService — wraps Firebase Cloud Messaging (FCM).
/// Handles push notification permissions and token management.
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token for this device
      final token = await _messaging.getToken();
      if (token != null) {
        // In production, save token to Firestore for targeted messaging
        // For MVP, just log it
      }
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification or in-app banner
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    // Navigate to relevant screen
    // Analytics: log notification_opened event
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
