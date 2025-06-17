import 'package:flutter/material.dart';

class SearchBarComponent extends StatelessWidget {
  final String? hintText;
  final VoidCallback? onTap;

  const SearchBarComponent({
    super.key,
    this.hintText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hintText ?? 'Search...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            Spacer(),
            Icon(
              Icons.search,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}