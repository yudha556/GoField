import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';

class MainAdminSchallfold extends StatelessWidget {
  final Widget child;
  final bool showNavBar;
  final String? title;

  const MainAdminSchallfold({
    super.key,
    required this.child,
    this.showNavBar = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            )
          : null,
      body: child,

      bottomNavigationBar: showNavBar
          ? Container(
              height: 90,
              padding: EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: _buildBottomNavBar(context),
            )
          : null,
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final String currentLocation = GoRouterState.of(context).uri.toString();

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: _getCurrentIndex(currentLocation),
      onTap: (index) => _onNavBarTap(context, index),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_customize_outlined),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.note_add_outlined),
          label: 'Permintaan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.discount_outlined),
          label: 'Promo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }

  int _getCurrentIndex(String location) {
    if (location.startsWith('/admin/home')) return 0;
    // if (location.startsWith('/user/jadwal')) return 1;
    if (location.startsWith('/admin/peninjauan')) return 2;
    // if (location.startsWith('/user/promo')) return 3;
    if (location.startsWith('/admin/profile')) return 4;
    return 0;
  }

  void _onNavBarTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.adminDashboard);
        break;
      // case 1:
      //   context.go(AppRoutes.userSearchPage);
      //   break;
      case 2:
        context.go(AppRoutes.adminPeninjauanPage);
        break;
      // case 3:
      //   context.go(AppRoutes.userpromoPage);
      //   break;
      case 4:
        context.go(AppRoutes.adminProfile);
        break;
    }
  }
}
