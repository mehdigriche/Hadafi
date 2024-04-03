import 'package:flutter/material.dart';

class HadafiButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;
  final bool isEnabled;

  const HadafiButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.black : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: isEnabled ? Colors.white : Colors.grey[100],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
