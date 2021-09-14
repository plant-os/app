import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/user_service.dart';

class NotificationService {
  AuthService authService = AuthService();
  UserService userService = UserService();

  Future<void> requestPermissions() async {
    // subscribe to topic on each app start-up
    var firebaseUser = await authService.getCurrentUser();
    var currentUser = await userService.getUserByEmail(firebaseUser!.email!);
    var companyId = currentUser?.company?.id;

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (companyId != null) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }

      var topic = 'customer.$companyId';
      await messaging.subscribeToTopic(topic);
      print("subscribed to $topic");
    }
  }
}
