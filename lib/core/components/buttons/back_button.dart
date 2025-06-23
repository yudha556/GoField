import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool showTitle;
  final EdgeInsetsGeometry? padding;

  const CustomBackButton({
    super.key,
    this.title,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.showTitle = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back button
          InkWell(
            onTap: onPressed ?? () => context.pop(),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: iconColor ?? Colors.grey.shade700,
              ),
            ),
          ),
          
          if (showTitle && title != null) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Variant yang lebih simple
class SimpleBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const SimpleBackButton({
    super.key,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => context.pop(),
      icon: Icon(
        Icons.arrow_back_ios,
        color: color ?? Colors.grey.shade700,
      ),
    );
  }
}
