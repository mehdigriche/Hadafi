import 'package:flutter/material.dart';

class HadafiSocialSignInButton extends StatelessWidget {
  final String imagePath;

  const HadafiSocialSignInButton({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Image.asset(
        imagePath,
        height: 70,
      ),
    );
  }
}
