import 'package:flutter/material.dart';

class HadafiTextField extends StatelessWidget {
  final dynamic controller;
  final String hintText;
  final bool isPassword;
  final dynamic onChanged;

  const HadafiTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isPassword,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: isPassword,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
