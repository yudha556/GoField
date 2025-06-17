import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  final int? itemCount;
  final VoidCallback? onTap;
  final Color? iconColor;
  // final Color? badgeColor;
  final double? iconSize;

  const CartButton({
    super.key,
    this.itemCount,
    this.onTap,
    this.iconColor,
    // this.badgeColor = Colors.red,
    this.iconSize = 26,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            color: iconColor ?? Colors.black,
            size: iconSize,
          ),
          if (itemCount != null && itemCount! > 0)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                // decoration: BoxDecoration(
                //   color: badgeColor,
                //   borderRadius: BorderRadius.circular(8),
                // ),
                child: Center(
                  child: Text(
                    itemCount! > 99 ? '99+' : itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
