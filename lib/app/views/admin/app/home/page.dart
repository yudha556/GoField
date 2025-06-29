import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/admin/layout/main_admin_schallfold.dart';
import 'package:gofield/core/router/app_routes.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
    Widget build(BuildContext context) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light, // IOS
        ),
        child: const MainAdminSchallfold(
          child: SafeArea(child: AdminContent()),
        ),
      );
    }
  }

 class AdminContent extends StatelessWidget {
  const AdminContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Text('ini adalah halaman dashboard admin')
        ],
      ),
    );
  }
}