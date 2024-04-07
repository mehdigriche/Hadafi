import 'package:flutter/material.dart';

class HadafiSocialSignInButton extends StatelessWidget {
  final String imagePath;
  final dynamic action;

  const HadafiSocialSignInButton(
      {super.key, required this.imagePath, required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GestureDetector(
          onTap: action,
          child: Image.asset(
            imagePath,
            height: 70,
          ),
        ),
      ),
    );
  }
}
