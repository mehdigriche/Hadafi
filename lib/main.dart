import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// * Important information
// ? Question
// TODO: a todo
// ! Alert

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure WidgetsBinding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Auth(),
    );
  }
}
