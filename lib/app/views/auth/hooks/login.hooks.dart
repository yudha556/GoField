import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/models/pengguna_model.dart';
import 'package:gofield/core/services/auth_service/auth_service.dart';
import 'dart:developer' as developer; // Replace print with developer.log

// Navigation hook based on user role
void useLoginHook(BuildContext context, PeranEnum role) {
  String routePath;

  switch (role) {
    case PeranEnum.admin:
      routePath = AppRoutes.adminDashboard;
      break;
    case PeranEnum.pemilik:
      routePath = AppRoutes.ownerDashboard;
      break;
    case PeranEnum.pengguna:
      routePath = AppRoutes.userDashboard;
      break;
    // Remove default case since all cases are covered
  }

  if (context.mounted) {
    context.go(routePath);
  }
}

// Hook untuk handle login dengan Supabase
Future<AuthResult> useAuthLogin(BuildContext context, String email, String password) async {
  try {
    final result = await AuthService.signInWithEmailPassword(
      email: email,
      password: password,
    );
    
    if (result.success && result.user != null) {
      // Get user profile to determine role
      final userProfile = await AuthService.getCurrentPengguna();
      if (userProfile != null && context.mounted) {
        useLoginHook(context, userProfile.peran);
      } else if (context.mounted) {
        // Default to user dashboard if profile not found
        context.go(AppRoutes.userDashboard);
      }
    }
    
    return result;
  } catch (e) {
    developer.log('Auth login hook error: $e', name: 'AuthHooks');
    return AuthResult(
      success: false,
      message: 'Terjadi kesalahan saat login: ${e.toString()}',
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
      peran: peran,
    );
    
    return result;
  } catch (e) {
    developer.log('Auth register hook error: $e', name: 'AuthHooks');
    return AuthResult(
      success: false,
      message: 'Terjadi kesalahan saat mendaftar: ${e.toString()}',
    );
  }
}

// Hook untuk logout
Future<void> useAuthLogout(BuildContext context) async {
  try {
    await AuthService.signOut();
    
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  } catch (e) {
    developer.log('Logout error: $e', name: 'AuthHooks');
    // Still navigate to login even if logout fails
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }
}

// Hook untuk reset password
Future<bool> useAuthResetPassword(String email) async {
  try {
    final result = await AuthService.resetPassword(email);
    return result.success;
  } catch (e) {
    developer.log('Reset password hook error: $e', name: 'AuthHooks');
    return false;
  }
}

// Hook untuk resend email confirmation
Future<bool> useResendEmailConfirmation(String email) async {
  try {
    final result = await AuthService.resendVerificationEmail(email);
    return result.success;
  } catch (e) {
    developer.log('Resend email confirmation hook error: $e', name: 'AuthHooks');
    return false;
  }
}

// Hook untuk get current user data
Future<PenggunaModel?> useCurrentPengguna() async {
  try {
    return await AuthService.getCurrentPengguna();
  } catch (e) {
    developer.log('Get current pengguna error: $e', name: 'AuthHooks');
    return null;
  }
}

// Hook untuk check user role
Future<bool> useHasRole(PeranEnum requiredRole) async {
  try {
    final user = await AuthService.getCurrentPengguna();
    return user?.peran == requiredRole;
  } catch (e) {
    developer.log('Check role error: $e', name: 'AuthHooks');
    return false;
  }
}

// Google Sign In hook (placeholder)
Future<GoogleSignInResult> useGoogleSignIn(BuildContext context, {bool isRegister = false}) async {
  try {
    // TODO: Implement Google Auth Service
    return GoogleSignInResult(
      success: false,
      message: 'Google Sign In belum diimplementasi.',
    );
  } catch (e) {
    developer.log('Google Sign In hook error: $e', name: 'AuthHooks');
    return GoogleSignInResult(
      success: false,
      message: 'Terjadi kesalahan saat login dengan Google: ${e.toString()}',
    );
  }
}

// Google Sign In Result Model
class GoogleSignInResult {
  final bool success;
  final String message;
  final PeranEnum? peran;
  final dynamic user;

  GoogleSignInResult({
    required this.success,
    required this.message,
    this.peran,
    this.user,
  });
}
