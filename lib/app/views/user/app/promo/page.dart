import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';

class PromoPage extends StatelessWidget {
  const PromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark, 
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainUserScaffold(
        showNavBar: true,
        child: SafeArea(child: PromoContent()),
      )
    );
  }
}

class PromoContent extends StatelessWidget {
  const PromoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('ini halaman promo')
        ],
      ),
    );
  }
}