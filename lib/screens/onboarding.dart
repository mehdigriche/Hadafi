import 'package:flutter/material.dart';
import '../components/hadafi_button.dart';
import '../database/hadafi_database.dart';
import '../screens/auth.dart';
import 'package:provider/provider.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  void initState() {
    HadafiDatabase().saveFirstLaunchDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hadafiDatabase = context.watch<HadafiDatabase>();
    return FutureBuilder<DateTime?>(
      future: hadafiDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // once the data is available -> show Auth Page
        if (snapshot.hasData) {
          debugPrint('${snapshot.data}');
          return const Auth();
        }
        // handle case where no data is returned
        else {
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade900,
            body: Stack(
              children: [
                Positioned(
                  top: -100,
                  left: -100,
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 50,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -150,
                  left: -150,
                  child: Container(
                    height: 500,
                    width: 500,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 350,
                  right: -150,
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 250,
                  right: 50,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 200,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            'Welcome to Hadafi',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 30,
                        ),
                        child: HadafiButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/onboarding');
                          },
                          buttonText: 'Next',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
