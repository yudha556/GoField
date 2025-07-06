import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final String id;

  const CheckoutPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'ini halaman checkout'
          )
        ],
      ),
    );
  }
}
