import 'package:flutter/material.dart';

class HadafiTextFieldDatePicker extends StatelessWidget {
  final dynamic controller;
  final String hintText;
  final dynamic onTap;

  const HadafiTextFieldDatePicker({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        onTap: onTap,
        readOnly: true,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
