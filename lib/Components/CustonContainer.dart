// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer({super.key, required this.child});

  late Widget? child;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(31),
                color: const Color.fromRGBO(61, 61, 61, 1)),
            child: child));
  }
}
