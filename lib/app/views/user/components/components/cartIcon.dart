import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  final int? itemCount;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? badgeColor;
  final double? iconSize;

  const CartButton({
    super.key,
    this.itemCount,
    this.onTap,
    this.iconColor,
    this.badgeColor = Colors.red,
    this.iconSize = 26,
  });

  @override
  Widget build(BuildContext context) {
    final double size = iconSize ?? 26;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size + 14,
        height: size + 14,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.shopping_cart_outlined,
                color: iconColor ?? Colors.black,
                size: size,
              ),
            ),
            if (itemCount != null && itemCount! > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      itemCount! > 99 ? '99+' : itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
