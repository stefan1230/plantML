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
import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print('Firebase initialized successfully');
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.MainGreen),
        // textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
        textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
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
