import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hadafi/database/hadafi_database.dart';
import 'package:hadafi/screens/home.dart';
import 'package:hadafi/screens/login.dart';
import 'package:hadafi/screens/profile.dart';
import 'package:hadafi/screens/register.dart';
import 'package:hadafi/screens/settings.dart';
import 'package:hadafi/theme/dark_mode.dart';
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
  await HadafiDatabase().saveFirstLaunchDate();

  // runApp(
  //   ChangeNotifierProvider(
  //     create: (context) => ThemeProvider(),
  //     child: const MyApp(),
  //   ),
  // );

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
      home: const Auth(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
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
