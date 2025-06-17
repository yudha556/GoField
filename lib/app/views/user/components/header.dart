import 'package:flutter/material.dart';
import 'package:gofield/app/views/user/components/components/cart.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Top Row - Actions
          Row(
            children: [
              const Spacer(),
              
              // Action Buttons
              Row(
                children: [
                  if (showNotification) ...[
                    NotificationButton(
                      notificationCount: notificationCount,
                      onTap: onNotificationTap,
                    ),
                    const SizedBox(width: 8),
                  ],
                  
                  if (showCart) ...[
                    CartButton(
                      itemCount: cartItemCount,
                      onTap: onCartTap,
                    ),
                    const SizedBox(width: 8),
                  ],
                  
                  if (showProfile)
                    ProfileButton(
                      profileImageUrl: profileImageUrl,
                      onTap: onProfileTap,
                    ),
                ],
              ),
            ],
          ),
          
          // Search Bar
          if (showSearch) ...[
            const SizedBox(height: 12),
            SearchBarComponent(
              hintText: searchHint ?? 'Cari lapangan...',
              onTap: onSearchTap,
            ),
          ],
        ],
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
    return HeaderBar(
      showSearch: false,
      showNotification: showNotification,
      showCart: showCart,
      showProfile: showProfile,
      notificationCount: notificationCount,
      cartItemCount: cartItemCount,
      profileImageUrl: profileImageUrl,
      onNotificationTap: onNotificationTap,
      onCartTap: onCartTap,
      onProfileTap: onProfileTap,
    );
  }
}

// Variant untuk halaman yang hanya butuh search bar
class SearchOnlyBar extends StatelessWidget {
  final String? searchHint;
  final VoidCallback? onSearchTap;

  const SearchOnlyBar({
    super.key,
    this.searchHint,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return HeaderBar(
      searchHint: searchHint,
      showNotification: false,
      showCart: false,
      showProfile: false,
      onSearchTap: onSearchTap,
    );
  }
}
