import 'package:flutter/material.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';

class TransaksiPage extends StatelessWidget {
  const TransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainUserScaffold(
      showNavBar: true,
      child: TransaksiContent(),
    );
  }
}

class TransaksiContent extends StatelessWidget {
  const TransaksiContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('iini halaman transaksi')
        ],
      ),
    );
  }
}