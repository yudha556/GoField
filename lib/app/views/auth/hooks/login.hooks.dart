import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/models/auth_result.dart';
import 'package:gofield/core/models/pengguna_model.dart';
import 'package:gofield/core/services/auth_service/auth_service.dart';
import 'package:gofield/core/services/auth_service/google_auth_service.dart';

void useLoginHook(BuildContext context, PeranEnum role) {
  String routePath;

  switch (role) {
    case PeranEnum.admin:
      routePath = AppRoutes.adminDashboard;
      break;
    case PeranEnum.pemilik:
      routePath = AppRoutes.ownerDashboard;
      break;
    default:
      routePath = AppRoutes.userDashboard;
  }

  context.go(routePath);
}

// Hook untuk handle login dengan Supabase
Future<AuthResult> useAuthLogin(BuildContext context, String email, String password) async {
  try {
    final result = await AuthService.signInWithEmailPassword(email, password);
    
    if (result.success && result.peran != null) {
      useLoginHook(context, result.peran!);
    }
    
    return result;
  } catch (e) {
    print('Auth login hook error: $e');
    return AuthResult(
      success: false,
      message: 'Terjadi kesalahan saat login.',
    );
  }
}

// Hook untuk handle register dengan Supabase
Future<AuthResult> useAuthRegister(BuildContext context, {
  required String email,
  required String password,
  required String namaLengkap,
  String? nomorTelepon,
  String? alamat,
  required PeranEnum peran,
}) async {
  try {
    final result = await AuthService.signUpWithEmailPassword(
      email: email,
      password: password,
      namaLengkap: namaLengkap,
      nomorTelepon: nomorTelepon,
      alamat: alamat,
      peran: peran,
    );
    
    return result;
  } catch (e) {
    print('Auth register hook error: $e');
    return AuthResult(
      success: false,
      message: 'Terjadi kesalahan saat mendaftar.',
    );
  }
}

// Google Sign In hook
Future<GoogleSignInResult> useGoogleSignIn(BuildContext context, {bool isRegister = false}) async {
  try {
    final result = await GoogleAuthService.signInWithGoogle(isRegister: isRegister);
    
    if (result.success && result.peran != null) {
      useLoginHook(context, result.peran!);
    }
    
    return result;
  } catch (e) {
    print('Google Sign In hook error: $e');
    return GoogleSignInResult(
      success: false,
      message: 'Terjadi kesalahan saat login dengan Google.',
    );
  }
}

// Hook untuk logout
Future<void> useAuthLogout(BuildContext context) async {
  try {
    // Sign out from Google if signed in
    if (await GoogleAuthService.isSignedInWithGoogle()) {
      await GoogleAuthService.signOutGoogle();
    }
    
    // Sign out from Supabase
    await AuthService.signOut();
    
    // Navigate to login
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  } catch (e) {
    print('Logout error: $e');
    // Still navigate to login even if logout fails
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }
}

// Hook untuk reset password
Future<bool> useAuthResetPassword(String email) async {
  try {
    return await AuthService.resetPassword(email);
  } catch (e) {
    print('Reset password hook error: $e');
    return false;
  }
}

// Hook untuk resend email confirmation
Future<bool> useResendEmailConfirmation(String email) async {
  try {
    return await AuthService.resendEmailConfirmation(email);
  } catch (e) {
    print('Resend email confirmation hook error: $e');
    return false;
  }
}

// Hook untuk get current user data
Future<PenggunaModel?> useCurrentPengguna() async {
  try {
    return await AuthService.getCurrentPengguna();
  } catch (e) {
    print('Get current pengguna error: $e');
    return null;
  }
}

// Hook untuk check user role
Future<bool> useHasRole(PeranEnum requiredRole) async {
  try {
    return await AuthService.hasRole(requiredRole);
  } catch (e) {
    print('Check role error: $e');
    return false;
  }
}

// Helper function untuk error messages
String _getLoginErrorMessage(String error) {
  if (error.contains('Invalid login credentials')) {
    return 'Email atau password salah';
  } else if (error.contains('Email not confirmed')) {
    return 'Email belum diverifikasi. Periksa inbox Anda.';
  } else if (error.contains('Too many requests')) {
    return 'Terlalu banyak percobaan. Coba lagi nanti.';
  } else if (error.contains('tidak aktif')) {
    return 'Akun Anda tidak aktif. Hubungi administrator.';
  }
  return 'Terjadi kesalahan saat login. Silakan coba lagi.';
}

String _getRegisterErrorMessage(String error) {
  if (error.contains('User already registered')) {
    return 'Email sudah terdaftar. Gunakan email lain atau login.';
  } else if (error.contains('Password should be at least 6 characters')) {
    return 'Password minimal 6 karakter';
  } else if (error.contains('Unable to validate email address')) {
    return 'Format email tidak valid';
  } else if (error.contains('Password is too weak')) {
    return 'Password terlalu lemah. Gunakan kombinasi huruf, angka, dan simbol.';
  } else if (error.contains('duplicate key value violates unique constraint')) {
    if (error.contains('email')) {
      return 'Email sudah terdaftar';
    } else if (error.contains('nomor_telepon')) {
      return 'Nomor telepon sudah terdaftar';
    }
  }
  return 'Terjadi kesalahan saat registrasi. Silakan coba lagi.';
}

// Result classes untuk better error handling
class LoginResult {
  final bool success;
  final String message;
  final bool needsEmailVerification;

  LoginResult({
    required this.success,
    required this.message,
    this.needsEmailVerification = false,
  });
}

class RegisterResult {
  final bool success;
  final String message;
  final bool needsEmailVerification;

  RegisterResult({
    required this.success,
    required this.message,
    this.needsEmailVerification = false,
  });
}
