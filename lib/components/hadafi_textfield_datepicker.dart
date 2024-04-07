import 'package:flutter/material.dart';
import 'package:hadafi/theme/theme_provider.dart';
import 'package:provider/provider.dart';

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
