import 'package:flutter/material.dart';
import 'package:hadafi/components/hadafi_appbar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HadafiAppBar(
        title: 'Profile',
        hasAvatar: false,
      ),
    );
  }
}
