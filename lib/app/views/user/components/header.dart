import 'package:flutter/material.dart';
import 'package:gofield/app/views/user/components/components/cartIcon.dart';
import 'package:gofield/app/views/user/components/components/notification.dart';
import 'package:gofield/app/views/user/components/components/profile_button.dart';
import 'package:gofield/app/views/user/components/components/searchBar.dart';

class HeaderBar extends StatelessWidget {
  final String? searchHint;
  final bool showSearch;
  final bool showNotification;
  final bool showCart;
  final bool showProfile;
  final int? notificationCount;
  final int? cartItemCount;
  final String? profileImageUrl;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;

  const HeaderBar({
    super.key,
    this.searchHint,
    this.showSearch = true,
    this.showNotification = true,
    this.showCart = true,
    this.showProfile = true,
    this.notificationCount,
    this.cartItemCount,
    this.profileImageUrl,
    this.onSearchTap,
    this.onNotificationTap,
    this.onCartTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          children: [
            // Notification Button
            if (showNotification) ...[
              NotificationButton(
                notificationCount: notificationCount,
                onTap: onNotificationTap,
              ),
              const SizedBox(width: 18),
            ],

            // Cart Button
            if (showCart) ...[
              CartButton(itemCount: cartItemCount, onTap: onCartTap),
              const SizedBox(width: 18),
            ],

            // Search Bar - mengambil space yang tersisa
            if (showSearch) ...[
              Expanded(
                child: SearchBarComponent(
                  hintText: searchHint ?? 'Cari lapangan...',
                  onTap: onSearchTap,
                ),
              ),
              const SizedBox(width: 18),
            ],

            // Profile Button
            if (showProfile)
              ProfileButton(profileImageUrl: null, onProfiletap: null),
          ],
        ),
      ),
    );
  }
}

// Variant untuk halaman yang hanya butuh action buttons (tanpa search)
class ActionBar extends StatelessWidget {
  final bool showNotification;
  final bool showCart;
  final bool showProfile;
  final int? notificationCount;
  final int? cartItemCount;
  final String? profileImageUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;

  const ActionBar({
    super.key,
    this.showNotification = true,
    this.showCart = true,
    this.showProfile = true,
    this.notificationCount,
    this.cartItemCount,
    this.profileImageUrl,
    this.onNotificationTap,
    this.onCartTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Notification Button
          if (showNotification) ...[
            NotificationButton(
              notificationCount: notificationCount,
              onTap: onNotificationTap,
            ),
            const SizedBox(width: 8),
          ],

          // Cart Button
          if (showCart) ...[
            CartButton(itemCount: cartItemCount, onTap: onCartTap),
            const SizedBox(width: 8),
          ],

          const Spacer(), // Mendorong profile button ke kanan
          // Profile Button
          if (showProfile)
            ProfileButton(onProfiletap: null, profileImageUrl: null),
        ],
      ),
    );
  }
}

// Variant untuk halaman yang hanya butuh search bar
class SearchOnlyBar extends StatelessWidget {
  final String? searchHint;
  final VoidCallback? onSearchTap;

  const SearchOnlyBar({super.key, this.searchHint, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SearchBarComponent(
              hintText: searchHint ?? 'Cari lapangan...',
              onTap: onSearchTap,
            ),
          ),
        ],
      ),
    );
  }
}
