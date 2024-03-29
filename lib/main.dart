import 'package:cab_booking_user/screens/home.dart';
import 'package:cab_booking_user/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (FirebaseAuth.instance.currentUser != null)
          ? UserPhoneNoLogin()
          // ? const HomeScreen()
          : UserPhoneNoLogin(),
    );
    //     MaterialApp(
    //   home: (FirebaseAuth.instance.currentUser != null)
    //       ? const AdminHomeScreen()
    //       : AdminPhoneNoLogin(),
    // );
  }
}
