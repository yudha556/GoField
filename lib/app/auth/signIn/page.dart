import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/components/components.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('LoginPage: build called');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Selamat datang di aplikasi Go Field!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 20.0),

              // form
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukan Email Anda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Masukan password anda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: const Icon(Icons.visibility_off),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 5.0),

              // lupa password button 
              Align(
                alignment: Alignment.centerRight,
                child: LinkButton(
                  text: 'Lupa Password?',
                  size: ButtonSize.small,
                  onPressed: () {
                    print('Forgot password pressed');
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              // login button 
              PrimaryButton(
                text: 'Login',
                size: ButtonSize.medium,
                isFullWidth: true,
                onPressed: () {
                  print('Login button pressed!');
                },
              ),
              const SizedBox(height: 24.0),

              Row(
                children: <Widget>[
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Atau Login Menggunakan',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20.0),

              // google icon button 
              Center(
                child: InkWell(
                  onTap: () {
                    print('Login with Google (icon only) pressed!');
                  },
                  borderRadius: BorderRadius.circular(28.0),
                  child: Container(
                    width: 56.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!, width: 1.5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      'assets/icons/icons-google.svg',
                      height: 24.0,
                      width: 24.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              // register button 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun?',
                    style: TextStyle(color: Colors.black),
                  ),
                  LinkButton(
                    text: 'Daftar Sekarang',
                    size: ButtonSize.small,
                    onPressed: () {
                      context.push(AppRoutes.register);
                      print('Register button pressed');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
