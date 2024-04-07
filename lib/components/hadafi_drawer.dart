import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadafi/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HadafiDrawer extends StatelessWidget {
  final String fullname;
  const HadafiDrawer({super.key, required this.fullname});

  void signOut(BuildContext context) async {
    debugPrint('Performing Logout');
    await FirebaseAuth.instance.signOut();
    if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // logo
              const DrawerHeader(
                child: Icon(Icons.heart_broken),
              ),
              // welcome message
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: Text(
                    'Welcome to Hadafis, \n $fullname',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // home
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('H O M E'),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);
                  },
                ),
              ),
              // profile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('P R O F I L E'),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);
                    // navigate to profile page
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ),
              // Settings
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('S E T T I N G S'),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);
                    // navigate to profile page
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ),
              // toggle theme
              // TODO : move to settings or profile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Provider.of<ThemeProvider>(context).isDarkMode
                      ? const Icon(Icons.light_mode)
                      : const Icon(Icons.mode_night),
                  title: Provider.of<ThemeProvider>(context).isDarkMode
                      ? const Text('Light mode')
                      : const Text('Dark mode'),
                  trailing: CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context).isDarkMode,
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                  ),
                ),
              ),
            ],
          ),
          // logout
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('L O G O U T'),
              onTap: () {
                signOut(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
