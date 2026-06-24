import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const SocialButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          foregroundColor: textColor ?? Color(0xFF222222),
          side: BorderSide(color: Color(0xFFEAEAEA), width: 1.5),
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
