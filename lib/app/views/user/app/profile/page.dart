import 'package:flutter/material.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainUserScaffold(
      showNavBar: true,
      child: ProfileContent(),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Ini halaman profie')
        ],
      ),
    );
  }
}