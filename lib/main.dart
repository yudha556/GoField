import 'package:flutter/material.dart';
import 'package:gofield/core/router/app_router.dart';
import 'package:gofield/core/constants/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/services/auth_service/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment variables
  await Env.init();

  // Initialize Supabase
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  // iitialisize auth listener
  AuthService.initAuthListener();
  // Print config for debugging
  Env.printConfig();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoField',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
