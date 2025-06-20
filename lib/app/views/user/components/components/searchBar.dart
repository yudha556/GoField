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
        padding: const EdgeInsets.symmetric(horizontal: 12), // Kurangi dari 16 ke 12
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [ // Hapus mainAxisAlignment: spaceBetween
            Expanded( // Wrap Text dengan Expanded
              child: Text(
                hintText ?? 'Search...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14, // Kurangi dari 16 ke 14
                ),
                overflow: TextOverflow.ellipsis, // Tambah overflow handling
              ),
            ),
            SizedBox(width: 8), // Tambah spacing tetap
            Icon(
              Icons.search,
              color: Colors.grey[600],
              size: 20, // Kurangi ukuran icon
            ),
          ],
        ),
      ),
    );
  }
}
