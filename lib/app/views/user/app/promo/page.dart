import 'package:flutter/material.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';

class PromoPage extends StatelessWidget {
  const PromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainUserScaffold(
      showNavBar: true,
      child: PromoContent(),
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