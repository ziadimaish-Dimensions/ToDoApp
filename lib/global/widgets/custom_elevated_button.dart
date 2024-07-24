import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final Color? color;
  final double? width;
  final double? height;
  final double? textSize;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconColor;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.width,
    this.height,
    this.textSize,
    this.textColor,
    this.borderColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? Colors.white,
        backgroundColor: color ?? const Color(0xFF8875FF),
        fixedSize: Size(width ?? double.infinity, height ?? 50),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: iconColor ?? Colors.white,
            ),
          if (icon != null)
            const SizedBox(
              width: 8,
            ),
          Text(
            text,
            style: TextStyle(
              fontSize: textSize ?? 16,
              color: textColor ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
