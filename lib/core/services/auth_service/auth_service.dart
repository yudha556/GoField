import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/services/auth_service/pengguna_service.dart';
import 'package:gofield/core/models/pengguna_model.dart';
import 'package:gofield/core/models/auth_result.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  // Sign up with email and password
  static Future<AuthResult> signUpWithEmailPassword({
    required String email,
    required String password,
    required String namaLengkap,
    String? nomorTelepon,
    String? alamat,
    required PeranEnum peran,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return AuthResult(
          success: false,
          message: 'Gagal membuat akun. Silakan coba lagi.',
        );
      }

      // Create pengguna record
      await PenggunaService.createPengguna(
        idPengguna: response.user!.id,
        namaLengkap: namaLengkap,
        email: email,
        nomorTelepon: nomorTelepon,
        alamat: alamat,
        peran: peran,
      );

      return AuthResult(
        success: true,
        message: 'Akun berhasil dibuat! Silakan cek email untuk verifikasi.',
        user: response.user,
        peran: peran,
        needsEmailVerification: !response.user!.emailConfirmedAt != null,
      );

    } catch (e) {
      print('Sign up error: $e');
      return AuthResult(
        success: false,
        message: _getAuthErrorMessage(e.toString()),
      );
    }
  }

  // Sign in with email and password
  static Future<AuthResult> signInWithEmailPassword(String email, String password) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return AuthResult(
          success: false,
          message: 'Email atau password salah.',
        );
      }

      // Check if email is confirmed
      if (response.user!.emailConfirmedAt == null) {
        return AuthResult(
          success: false,
          message: 'Email belum diverifikasi. Silakan cek email Anda.',
          needsEmailVerification: true,
        );
      }

      // Get user role from pengguna table
      final pengguna = await PenggunaService.getPenggunaById(response.user!.id);
      
      if (pengguna == null) {
        return AuthResult(
          success: false,
          message: 'Data pengguna tidak ditemukan.',
        );
      }

      if (!pengguna.aktif) {
        return AuthResult(
          success: false,
          message: 'Akun Anda tidak aktif. Hubungi administrator.',
        );
      }

      return AuthResult(
        success: true,
        message: 'Login berhasil!',
        user: response.user,
        peran: pengguna.peran,
      );

    } catch (e) {
      print('Sign in error: $e');
      return AuthResult(
        success: false,
        message: _getAuthErrorMessage(e.toString()),
      );
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Reset password
  static Future<bool> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }

  // Resend email confirmation
  static Future<bool> resendEmailConfirmation(String email) async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
      return true;
    } catch (e) {
      print('Resend email confirmation error: $e');
      return false;
    }
  }

  // Get current user
  static User? get currentUser => _supabase.auth.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => _supabase.auth.currentUser != null;

  // Helper method for error messages
  static String _getAuthErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Email atau password salah.';
    } else if (error.contains('Email not confirmed')) {
      return 'Email belum diverifikasi. Silakan cek email Anda.';
    } else if (error.contains('User already registered')) {
      return 'Email sudah terdaftar. Silakan login atau gunakan email lain.';
    } else if (error.contains('Password should be at least 6 characters')) {
      return 'Password minimal 6 karakter.';
    } else if (error.contains('Unable to validate email address')) {
      return 'Format email tidak valid.';
    } else if (error.contains('Network request failed')) {
      return 'Tidak ada koneksi internet. Periksa koneksi Anda.';
    }
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}
