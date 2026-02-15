import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String? buttonText;
  final Color? backgroundColor;
  final Color? textColor;
  final String? buttonIcon;
  final IconData? icon;
  final double? iconSize;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    this.buttonText,
    this.textColor,
    this.onPressed,
    this.backgroundColor,
    this.buttonIcon,
    this.iconSize,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButton();
}

class _CustomButton extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 48),
        backgroundColor: widget.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          if (widget.buttonIcon != null)
            Image.asset(
              widget.buttonIcon!,
              width: widget.iconSize ?? 24,
            )
          else if (widget.icon != null)
            Icon(widget.icon),
          Text(
            widget.buttonText?.toUpperCase() ?? "",
            style: TextStyle(
              color: widget.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
