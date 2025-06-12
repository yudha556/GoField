import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/splash/page.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/app/auth/register/page.dart';
import 'package:gofield/app/auth/signIn/page.dart';
// import 'package:gofield/app/app/home/page.dart';
// import 'package:gofield/app/app/profile/page.dart';
// import 'package:gofield/main.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // splash
      GoRoute(
        path: AppRoutes.splash,
        name: 'SplashPage',
        builder: (context, state) {
          print("Router: Building splash page");
          return const SplashPage();
        },
      ),

      // auth
      GoRoute(
        path: AppRoutes.login,
        name: 'Login',
        builder: (context, state) {
          print("Router: Building Login page");
          return const LoginPage();
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'Register',
        builder: (context, state) {
          print('Router: Building Register page');
          return const RegisterPage();
        },
      ),

      // main app
      // GoRoute(
      //   path: AppRoutes.home,
      //   name: 'home',
      //   builder: (context, state) => const HomePage(),
      // ),
      // GoRoute(
      //   path: AppRoutes.profile,
      //   name: 'profile',
      //   builder: (context, state) => const ProfilePage(),
      // ),
    ],

    errorBuilder: (context, state) {
      print('Router Error: ${state.error}');
      print('Router Error Location: ${state.uri}');
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Page not found: ${state.uri}'),
              Text('Error: ${state.error}'),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
