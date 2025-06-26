import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark, 
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainUserScaffold(child: SafeArea(child: SearchContent()))
    );
  }
}

class SearchContent extends StatelessWidget {
  const SearchContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('ini halaman search')
        ],
      ),
    );
  }
}