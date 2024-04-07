import 'package:flutter/material.dart';
import 'package:hadafi/theme/theme_provider.dart';
import 'package:provider/provider.dart';

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
        style: TextStyle(
          color: Provider.of<ThemeProvider>(context).isDarkMode
              ? Colors.white
              : Colors.grey.shade800,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Theme.of(context).colorScheme.tertiary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? Colors.grey
                : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
