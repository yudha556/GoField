import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark, 
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainUserScaffold(child: SafeArea(child: JadwalContent()))
    );
  }
}

class JadwalContent extends StatelessWidget {
  const JadwalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('ini halaman jadwal')
        ],
      ),
    );
  }
}