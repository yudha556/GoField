import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/models/pengguna_model.dart';

class AuthResult {
  final bool success;
  final String message;
  final User? user;
  final PeranEnum? peran;
  final bool needsEmailVerification;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.peran,
    this.needsEmailVerification = false,
  });
}