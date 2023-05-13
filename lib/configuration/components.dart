import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const LargeButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
