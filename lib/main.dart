// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantdiseaseidentifcationml/app_color.dart';
import 'package:plantdiseaseidentifcationml/firebase_options.dart';
import 'package:plantdiseaseidentifcationml/screens/controller_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/login_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantdiseaseidentifcationml/services/firebase_messaging_service.dart';
import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FirebaseMessagingService _messagingService = FirebaseMessagingService();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform);
//     await FirebaseMessagingService().initNotification();
//     print('Firebase initialized successfully');
//   } catch (e) {
//     print('Failed to initialize Firebase: $e');
//   }
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print('Firebase initialized successfully');

    // Initialize Firebase Messaging Service
    await _messagingService.initialize();

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    print('Firebase Messaging initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: AppColors.MainGreen),
        // scaffoldBackgroundColor:
        //     Color.fromARGB(255, 218, 219, 240).withOpacity(0.2),
        // textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          } else {
            return const ControllerScreen();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
