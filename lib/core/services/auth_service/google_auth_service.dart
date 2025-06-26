import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/services/auth_service/pengguna_service.dart';
import 'package:gofield/core/models/pengguna_model.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  
  static final _supabase = Supabase.instance.client;

  // Sign in with Google
  static Future<GoogleSignInResult> signInWithGoogle({bool isRegister = false}) async {
    try {
      // Sign out first to ensure fresh login
      await _googleSignIn.signOut();
      
      // Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return GoogleSignInResult(
          success: false,
          message: 'Login dibatalkan',
        );
      }

      // Get Google authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        return GoogleSignInResult(
          success: false,
          message: 'Gagal mendapatkan token Google',
        );
      }

      // Sign in to Supabase with Google token
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (response.user == null) {
        return GoogleSignInResult(
          success: false,
          message: 'Gagal login dengan Google',
        );
      }

      // Check if user exists in pengguna table
      final existingPengguna = await PenggunaService.getPenggunaById(response.user!.id);
      
      if (existingPengguna == null) {
        // Create new pengguna record for Google user
        await PenggunaService.createPengguna(
          idPengguna: response.user!.id,
          namaLengkap: googleUser.displayName ?? 'Google User',
          email: googleUser.email,
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
      final pengguna = await PenggunaService.getPenggunaById(response.user!.id);
      final peran = pengguna?.peran ?? PeranEnum.pengguna;

      return GoogleSignInResult(
        success: true,
        message: isRegister ? 'Registrasi berhasil!' : 'Login berhasil!',
        user: response.user,
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

  // Sign out from Google
  static Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Google Sign Out error: $e');
    }
  }

  // Check if user is signed in with Google
  static Future<bool> isSignedInWithGoogle() async {
    try {
      return await _googleSignIn.isSignedIn();
    } catch (e) {
      print('Check Google Sign In status error: $e');
      return false;
    }
  }

  // Get current Google user
  static GoogleSignInAccount? get currentGoogleUser => _googleSignIn.currentUser;

  // Helper method for error messages
  static String _getGoogleErrorMessage(String error) {
    if (error.contains('network_error')) {
      return 'Tidak ada koneksi internet. Periksa koneksi Anda.';
    } else if (error.contains('sign_in_canceled')) {
      return 'Login dibatalkan';
    } else if (error.contains('sign_in_failed')) {
      return 'Login Google gagal. Silakan coba lagi.';
    } else if (error.contains('account_exists_with_different_credential')) {
      return 'Email sudah terdaftar dengan metode login lain.';
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
