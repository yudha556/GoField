import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  final int? notificationCount;
  final VoidCallback? onTap;
  final Color? iconColor;
  final double? iconSize;

  const NotificationButton({
    super.key,
    this.notificationCount,
    this.onTap,
    this.iconColor,
    this.iconSize = 26,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Icon(
            Icons.notifications_active_outlined,
            color: iconColor ?? Colors.black,
            size: iconSize,
          ),
          if (notificationCount != null && notificationCount! > 0)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(
                  child: Text(
                    notificationCount! > 99 ? '99+' : notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
