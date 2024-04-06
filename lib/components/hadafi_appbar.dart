import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class HadafiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HadafiAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  void signOut() async {
    debugPrint('Performing Logout');
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: hadafiBGColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: hadafiBlack,
            size: 30,
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.jpeg'),
            ),
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: TextButton(
              onPressed: signOut,
              child: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }
}
