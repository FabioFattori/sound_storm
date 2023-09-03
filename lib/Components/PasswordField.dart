// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  PasswordField({Key? key, required this.label, required this.controller})
      : super(key: key);

  late String label;
  late TextEditingController controller;

  bool showPassword = true;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: widget.controller,
      obscureText: widget.showPassword,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.white),
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: Icon(
            widget.showPassword ? Icons.visibility : Icons.visibility_off,color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              widget.showPassword = !widget.showPassword;
            });
          },
        ),
      ),
    );
  }
}