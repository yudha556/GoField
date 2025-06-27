import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/models/pengguna_model.dart';

class AuthResult {
  final bool success;
  final String message;
  final User? user;
  final bool? needsEmailVerification;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.needsEmailVerification,
  });
}

class AuthService {
  static final _supabase = Supabase.instance.client;

  // Sign up with email verification
  static Future<AuthResult> signUpWithEmailPassword({
    required String email,
    required String password,
    required String namaLengkap,
    required PeranEnum peran,
    String? nomorTelepon,
  }) async {
    try {
      // Step 1: Create auth user WITHOUT custom redirect
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
        // Remove emailRedirectTo for now - let Supabase handle default
      );

      if (authResponse.user == null) {
        return AuthResult(
          success: false,
          message: 'Gagal membuat akun. Silakan coba lagi.',
        );
      }

      // Step 2: Insert user data to pengguna table
      final userData = {
        'id_pengguna': authResponse.user!.id,
        'nama_lengkap': namaLengkap,
        'user_email': email,
        'nomor_telepon': nomorTelepon ?? '000000000',
        'peran': peran.name,
      };

      print('Creating user profile: $userData');

      final profileResponse = await _supabase
          .from('pengguna')
          .insert(userData)
          .select();

      print('Profile created: $profileResponse');

      // Step 3: Sign out user (they need to verify email first)
      await _supabase.auth.signOut();

      return AuthResult(
        success: true,
        message: 'Akun berhasil dibuat! Silakan cek email Anda untuk verifikasi.',
        needsEmailVerification: true,
        user: authResponse.user,
      );

    } on AuthException catch (e) {
      print('Auth Error: ${e.message}');
      
      String errorMessage = 'Terjadi kesalahan saat membuat akun.';
      if (e.message.contains('already registered')) {
        errorMessage = 'Email sudah terdaftar. Silakan gunakan email lain.';
      } else if (e.message.contains('password')) {
        errorMessage = 'Password terlalu lemah. Minimal 6 karakter.';
      }
      
      return AuthResult(
        success: false,
        message: errorMessage,
      );
    } on PostgrestException catch (e) {
      print('Database Error: ${e.message}');
      
      // If profile creation fails, we should ideally clean up auth user
      // But Supabase doesn't allow client-side user deletion
      
      String errorMessage = 'Gagal menyimpan data profil.';
      if (e.code == '23505') { // Unique constraint violation
        errorMessage = 'Data sudah ada. Silakan gunakan data yang berbeda.';
      }
      
      return AuthResult(
        success: false,
        message: errorMessage,
      );
    } catch (e) {
      print('General Error: $e');
      return AuthResult(
        success: false,
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  // Sign in
  static Future<AuthResult> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return AuthResult(
          success: false,
          message: 'Login gagal. Periksa email dan password Anda.',
        );
      }

      // Check if email is verified
      if (response.user!.emailConfirmedAt == null) {
        await _supabase.auth.signOut();
        return AuthResult(
          success: false,
          message: 'Email belum diverifikasi. Silakan cek email Anda.',
          needsEmailVerification: true,
        );
      }

      return AuthResult(
        success: true,
        message: 'Login berhasil!',
        user: response.user,
      );

    } on AuthException catch (e) {
      print('Login Error: ${e.message}');
      
      String errorMessage = 'Login gagal.';
      if (e.message.contains('Invalid login credentials')) {
        errorMessage = 'Email atau password salah.';
      } else if (e.message.contains('Email not confirmed')) {
        errorMessage = 'Email belum diverifikasi. Silakan cek email Anda.';
      }
      
      return AuthResult(
        success: false,
        message: errorMessage,
      );
    } catch (e) {
      print('Login General Error: $e');
      return AuthResult(
        success: false,
        message: 'Terjadi kesalahan: ${e.toString()}',
      );
    }
  }

  // Resend verification email
  static Future<AuthResult> resendVerificationEmail(String email) async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );

      return AuthResult(
        success: true,
        message: 'Email verifikasi telah dikirim ulang.',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Gagal mengirim ulang email verifikasi.',
      );
    }
  }

  // Get current user
  static User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Sign out
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return _supabase.auth.currentUser != null;
  }

  // Get current user profile from pengguna table
  static Future<PenggunaModel?> getCurrentPengguna() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('pengguna')
          .select()
          .eq('id_pengguna', user.id)
          .single();

      return PenggunaModel.fromJson(response);
    } catch (e) {
      print('Get current pengguna error: $e');
      return null;
    }
  }

  // Reset password
  static Future<AuthResult> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return AuthResult(
        success: true,
        message: 'Link reset password telah dikirim ke email Anda.',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Gagal mengirim email reset password.',
      );
    }
  }

  // Check if user has specific role
  static Future<bool> hasRole(PeranEnum requiredRole) async {
    try {
      final pengguna = await getCurrentPengguna();
      return pengguna?.peran == requiredRole;
    } catch (e) {
      return false;
    }
  }
}
