import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hadafi/screens/onboarding.dart';
import '../database/hadafi_database.dart';
import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/profile.dart';
import '../screens/register.dart';
import '../screens/settings.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import '../screens/auth.dart';

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

  // initialize local database
  await HadafiDatabase.initialize();

  runApp(MultiProvider(
    providers: [
      // hadaf provider
      ChangeNotifierProvider(create: (context) => HadafiDatabase()),

      // theme provider
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnBoarding(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/onboarding': (context) => const OnBoarding(),
        '/auth': (context) => const Auth(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/home': (context) => const Home(),
        '/profile': (context) => const Profile(),
        '/settings': (context) => const Settings(),
      },
      // darkTheme: darkMode,
    );
  }
}
