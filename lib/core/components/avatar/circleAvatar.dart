import 'package:flutter/material.dart';

class Circleavatar extends StatelessWidget {
  final int? profileImageUrl;
  final VoidCallback? onProfiletap;

  const Circleavatar({super.key, this.profileImageUrl, this.onProfiletap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onProfiletap != null) {
          // context.go();
        }
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 8,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: profileImageUrl != null
        ? ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.asset(
            'assets/images/contoh.jpg',
            fit: BoxFit.cover,
          ),
        )
        : const Icon(
          Icons.person,
          color: Colors.grey,
          size: 24,
        ),
      ),
    );
  }
}
