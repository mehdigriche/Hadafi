import 'package:flutter/material.dart';
import 'package:hadafi/components/hadafi_appbar.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HadafiAppBar(
        title: 'Settings',
        hasAvatar: false,
      ),
    );
  }
}
