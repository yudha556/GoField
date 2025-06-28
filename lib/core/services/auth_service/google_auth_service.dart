import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/services/auth_service/pengguna_service.dart';
import 'package:gofield/core/models/pengguna_model.dart';
// import 'package:url_launcher/url_launcher.dart';

class GoogleAuthService {
  static final _supabase = Supabase.instance.client;

  // Sign in with Google using Supabase OAuth
  static Future<GoogleSignInResult> signInWithGoogle({bool isRegister = false}) async {
    try {
      // Method yang benar untuk Supabase OAuth
      final bool result = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.gofield://login-callback/',
      );

      if (!result) {
        return GoogleSignInResult(
          success: false,
          message: 'Gagal memulai login Google',
        );
      }

      // Tunggu sampai user kembali dari OAuth flow
      await _waitForAuthStateChange();

      final user = _supabase.auth.currentUser;
      
      if (user == null) {
        return GoogleSignInResult(
          success: false,
          message: 'Login Google dibatalkan atau gagal',
        );
      }

      // Check if user exists in pengguna table
      final existingPengguna = await PenggunaService.getPenggunaById(user.id);
      
      if (existingPengguna == null) {
        // Create new pengguna record for Google user
        final displayName = user.userMetadata?['full_name'] as String? ?? 
                           user.userMetadata?['name'] as String? ?? 
                           user.email?.split('@')[0] ?? 
                           'Google User';
        
        await PenggunaService.createPengguna(
          idPengguna: user.id,
          namaLengkap: displayName,
          email: user.email ?? '',
          peran: PeranEnum.pengguna,
        );
      } else if (!existingPengguna.aktif) {
        // User exists but inactive
        await _supabase.auth.signOut();
        return GoogleSignInResult(
          success: false,
          message: 'Akun Anda tidak aktif. Hubungi administrator.',
        );
      }

      // Get user role
      final pengguna = await PenggunaService.getPenggunaById(user.id);
      final peran = pengguna?.peran ?? PeranEnum.pengguna;

      return GoogleSignInResult(
        success: true,
        message: isRegister ? 'Registrasi berhasil!' : 'Login berhasil!',
        user: user,
        peran: peran,
      );

    } catch (e) {
      print('Google Sign In error: $e');
      return GoogleSignInResult(
        success: false,
        message: _getGoogleErrorMessage(e.toString()),
      );
    }
  }

  // Wait for auth state change after OAuth
  static Future<void> _waitForAuthStateChange() async {
    try {
      // Tunggu maksimal 30 detik untuk auth state change
      await _supabase.auth.onAuthStateChange
          .where((state) => 
              state.event == AuthChangeEvent.signedIn || 
              state.event == AuthChangeEvent.signedOut)
          .timeout(const Duration(seconds: 30))
          .first;
    } catch (e) {
      print('Timeout waiting for auth state change: $e');
      throw Exception('Login timeout');
    }
  }

  // Sign out
  static Future<void> signOutGoogle() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      print('Google Sign Out error: $e');
    }
  }

  // Check if user is signed in with Google
  static Future<bool> isSignedInWithGoogle() async {
    try {
      final user = _supabase.auth.currentUser;
      return user != null && 
             (user.appMetadata['provider'] == 'google' || 
              user.appMetadata['providers']?.contains('google') == true);
    } catch (e) {
      print('Check Google Sign In status error: $e');
      return false;
    }
  }

  // Get current user
  static User? get currentGoogleUser => _supabase.auth.currentUser;

  // Helper method for error messages
  static String _getGoogleErrorMessage(String error) {
    if (error.contains('network_error') || error.contains('NetworkException')) {
      return 'Tidak ada koneksi internet. Periksa koneksi Anda.';
    } else if (error.contains('cancelled') || error.contains('user_cancelled')) {
      return 'Login dibatalkan';
    } else if (error.contains('timeout')) {
      return 'Login timeout. Silakan coba lagi.';
    } else if (error.contains('oauth_error')) {
      return 'Login Google gagal. Silakan coba lagi.';
    } else if (error.contains('invalid_request')) {
      return 'Permintaan tidak valid. Periksa konfigurasi Google OAuth.';
    } else if (error.contains('access_denied')) {
      return 'Akses ditolak. Silakan berikan izin yang diperlukan.';
    }
    return 'Terjadi kesalahan saat login dengan Google.';
  }
}

// Result class for Google Sign In
class GoogleSignInResult {
  final bool success;
  final String message;
  final User? user;
  final PeranEnum? peran;

  GoogleSignInResult({
    required this.success,
    required this.message,
    this.user,
    this.peran,
  });
}
