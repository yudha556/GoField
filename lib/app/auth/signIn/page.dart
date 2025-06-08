import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('LoginPage: build called');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: const Center(
          child: Text(
            'LOGIN PAGE - SUCCESS!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
