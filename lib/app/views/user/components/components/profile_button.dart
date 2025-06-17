import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final int? profileImageUrl;
  final VoidCallback? onProfiletap;
  
  const ProfileButton({
    super.key,
    this.profileImageUrl,
    this.onProfiletap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onProfiletap != null) {
          // Handle profile tap
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: profileImageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  profileImageUrl.toString(),
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