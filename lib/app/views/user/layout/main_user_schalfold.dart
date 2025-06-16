import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';

class MainUserScaffold extends StatelessWidget {
  final Widget child;
  final bool showNavBar;
  final String? title;

  const MainUserScaffold({
    super.key,
    required this.child,
    this.showNavBar = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null 
        ? AppBar(
            title: Text(title!),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          )
        : null,
      body: child,
      bottomNavigationBar: showNavBar ? _buildBottomNavBar(context) : null,
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final String currentLocation = GoRouterState.of(context).uri.toString();
    
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(currentLocation),
      onTap: (index) => _onNavBarTap(context, index),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Jadwal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Transaksi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: 'Promo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  int _getCurrentIndex(String location) {
    if (location.startsWith('/user/home')) return 0;
    if (location.startsWith('/user/jadwal')) return 1;
    if (location.startsWith('/user/transaksi')) return 2;
    if (location.startsWith('/user/promo')) return 3;
    if (location.startsWith('/user/profile')) return 4;
    return 0;
  }

  void _onNavBarTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.userhomePage);
        break;
      case 1:
        context.go(AppRoutes.userjadwalPage);
        break;
      case 2:
        context.go(AppRoutes.usertransaksiPage);
        break;
      case 3:
        context.go(AppRoutes.userpromoPage);
        break;
      case 4:
        context.go(AppRoutes.userprofilePage);
        break;
    }
  }
}
