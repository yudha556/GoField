import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/models/pengguna_model.dart';
import 'package:gofield/core/constants/env.dart';
import 'dart:async';

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
  
  static final StreamController<AuthState> _authStateController = 
      StreamController<AuthState>.broadcast();
  
  static void initAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) {
      print('Auth state changed: ${data.event}');
      print('User: ${data.session?.user?.email}');
      _authStateController.add(data);
    });
  }

  static Stream<AuthState> get authStateChanges => _authStateController.stream;

  static Future<void> checkAvailableProviders() async {
    try {
      print('Supabase URL from Env: ${Env.supabaseUrl}');
      print('Supabase Key from Env: ${Env.supabaseAnonKey.substring(0, 20)}...');
      print('Is Supabase configured: ${Env.isSupabaseConfigured}');
      print('App Name: ${Env.appName}');
      print('Debug Mode: ${Env.isDebug}');
      
    } catch (e) {
      print('Provider check error: $e');
    }
  }

  // Sign up with Google OAuth - Updated untuk mobile
  static Future<AuthResult> signUpWithGoogle({
    required PeranEnum peran,
  }) async {
    try {
      print('Starting Google OAuth flow...');
      
      if (!Env.isSupabaseConfigured) {
        return AuthResult(
          success: false,
          message: 'Konfigurasi Supabase belum lengkap.',
        );
      }

      // deep links
      const String redirectUrl = 'com.example.gofield://auth/callback'; 
      
      final bool result = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      if (!result) {
        return AuthResult(
          success: false,
          message: 'Gagal memulai proses pendaftaran dengan Google.',
        );
      }

      final completer = Completer<AuthResult>();
      late StreamSubscription subscription;
      
      final timeout = Timer(const Duration(seconds: 60), () {
        if (!completer.isCompleted) {
          subscription.cancel();
          completer.complete(AuthResult(
            success: false,
            message: 'Timeout: Proses pendaftaran memakan waktu terlalu lama.',
          ));
        }
      });

      subscription = authStateChanges.listen((authState) async {
        if (authState.event == AuthChangeEvent.signedIn && authState.session?.user != null) {
          timeout.cancel();
          subscription.cancel();
          
          final callbackResult = await handleGoogleCallback(
            peran: peran,
            isSignUp: true,
          );
          
          if (!completer.isCompleted) {
            completer.complete(callbackResult);
          }
        } else if (authState.event == AuthChangeEvent.signedOut) {
          timeout.cancel();
          subscription.cancel();
          
          if (!completer.isCompleted) {
            completer.complete(AuthResult(
              success: false,
              message: 'Pendaftaran dibatalkan atau gagal.',
            ));
          }
        }
      });

      return completer.future;

    } on AuthException catch (e) {
      print('Google Sign-Up Auth Error: ${e.message}');
      
      String errorMessage = 'Gagal mendaftar dengan Google.';
      if (e.message.contains('redirect_uri_mismatch')) {
        errorMessage = 'Konfigurasi Google OAuth belum benar.\n\nPastikan di Google Cloud Console:\n• Authorized redirect URIs: com.example.gofield://auth/callback';
      } else if (e.message.contains('provider is not enabled')) {
        errorMessage = 'Google Sign-In belum diaktifkan di Supabase Dashboard.';
      } else if (e.message.contains('popup_closed_by_user')) {
        errorMessage = 'Pendaftaran dibatalkan oleh pengguna.';
      }
      
      return AuthResult(
        success: false,
        message: errorMessage,
      );
    } catch (e) {
      print('Google Sign-Up General Error: $e');
      return AuthResult(
        success: false,
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  // Sign in with Google OAuth
  static Future<AuthResult> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In flow...');
      
      if (!Env.isSupabaseConfigured) {
        return AuthResult(
          success: false,
          message: 'Konfigurasi Supabase belum lengkap.',
        );
      }
      
      const String redirectUrl = 'com.example.gofield://auth/callback'; 
      
      final bool result = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      if (!result) {
        return AuthResult(
          success: false,
          message: 'Gagal memulai proses login dengan Google.',
        );
      }

      // Tunggu sampai auth state berubah atau timeout
      final completer = Completer<AuthResult>();
      late StreamSubscription subscription;
      
      // Set timeout 60 detik
      final timeout = Timer(const Duration(seconds: 60), () {
        if (!completer.isCompleted) {
          subscription.cancel();
          completer.complete(AuthResult(
            success: false,
            message: 'Timeout: Proses login memakan waktu terlalu lama.',
          ));
        }
      });

      subscription = authStateChanges.listen((authState) async {
        if (authState.event == AuthChangeEvent.signedIn && authState.session?.user != null) {
          timeout.cancel();
          subscription.cancel();
          
          final callbackResult = await handleGoogleCallback(
            peran: PeranEnum.pengguna, 
            isSignUp: false,
          );
          
          if (!completer.isCompleted) {
            completer.complete(callbackResult);
          }
        } else if (authState.event == AuthChangeEvent.signedOut) {
          timeout.cancel();
          subscription.cancel();
          
          if (!completer.isCompleted) {
            completer.complete(AuthResult(
              success: false,
              message: 'Login dibatalkan atau gagal.',
            ));
          }
        }
      });

      return completer.future;

    } on AuthException catch (e) {
      print('Google Sign-In Auth Error: ${e.message}');
      
      String errorMessage = 'Gagal login dengan Google.';
      if (e.message.contains('redirect_uri_mismatch')) {
        errorMessage = 'Konfigurasi Google OAuth belum benar.\n\nPastikan di Google Cloud Console:\n• Authorized redirect URIs: ${Env.supabaseUrl}/auth/v1/callback';
      } else if (e.message.contains('popup_closed_by_user')) {
        errorMessage = 'Login dibatalkan oleh pengguna.';
      }
      
      return AuthResult(
        success: false,
        message: errorMessage,
      );
    } catch (e) {
      print('Google Sign-In General Error: $e');
      return AuthResult(
        success: false,
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  // Handle OAuth callback
  static Future<AuthResult> handleGoogleCallback({
    required PeranEnum peran,
    bool isSignUp = false,
  }) async {
    try {
      final User? user = _supabase.auth.currentUser;
      
      if (user == null) {
        return AuthResult(
          success: false,
          message: 'Gagal mendapatkan informasi pengguna dari Google.',
        );
      }

      if (Env.isDebug) {
        print('Google user data: ${user.userMetadata}');
        print('User email: ${user.email}');
        print('User ID: ${user.id}');
      }

      final existingUser = await _supabase
          .from('pengguna')
          .select()
          .eq('id_pengguna', user.id)
          .maybeSingle();

      if (existingUser != null && isSignUp) {
        return AuthResult(
          success: true,
          message: 'Akun sudah terdaftar. Login berhasil!',
          user: user,
        );
      }

      if (existingUser == null && !isSignUp) {
        return AuthResult(
          success: false,
          message: 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.',
        );
      }

      if (existingUser == null && isSignUp) {
        final userData = {
          'id_pengguna': user.id,
          'nama_lengkap': user.userMetadata?['full_name'] ?? 
                         user.userMetadata?['name'] ?? 
                         user.email?.split('@')[0] ?? 
                         'Pengguna Google',
          'user_email': user.email ?? '',
          'nomor_telepon': '000000000',
          'peran': peran.name,
          'foto_profil': user.userMetadata?['avatar_url'] ?? 
                        user.userMetadata?['picture'],
        };

        if (Env.isDebug) {
          print('Creating Google user profile: $userData');
        }

        final profileResponse = await _supabase
            .from('pengguna')
            .insert(userData)
            .select();

        if (Env.isDebug) {
          print('Google profile created: $profileResponse');
        }

        return AuthResult(
          success: true,
          message: 'Pendaftaran dengan Google berhasil!',
          user: user,
        );
      } else {
        return AuthResult(
          success: true,
          message: 'Login dengan Google berhasil!',
          user: user,
        );
      }

    } on PostgrestException catch (e) {
      print('Database Error in Google callback: ${e.message}');
      
      String errorMessage = 'Gagal menyimpan data profil Google.';
      if (e.code == '23505') {
        errorMessage = 'Data sudah ada. Login berhasil!';
        return AuthResult(
          success: true,
          message: errorMessage,
          user: _supabase.auth.currentUser,
        );
      }
      
      return AuthResult(
        success: false,
        message: errorMessage,
      );
    } catch (e) {
      print('Google Callback General Error: $e');
      return AuthResult(
        success: false,
        message: 'Terjadi kesalahan saat memproses akun Google: ${e.toString()}',
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

  // Sign up with email verification
  static Future<AuthResult> signUpWithEmailPassword({
    required String email,
    required String password,
    required String namaLengkap,
    required PeranEnum peran,
    String? nomorTelepon,
  }) async {
    try {
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        return AuthResult(
          success: false,
          message: 'Gagal membuat akun. Silakan coba lagi.',
        );
      }

      final userData = {
        'id_pengguna': authResponse.user!.id,
        'nama_lengkap': namaLengkap,
        'user_email': email,
        'nomor_telepon': nomorTelepon ?? '000000000',
        'peran': peran.name,
      };

      if (Env.isDebug) {
        print('Creating user profile: $userData');
      }

      final profileResponse = await _supabase
          .from('pengguna')
          .insert(userData)
          .select();

      if (Env.isDebug) {
        print('Profile created: $profileResponse');
      }

      await _supabase.auth.signOut();

      return AuthResult(
        success: true,
        message: 'Akun berhasil dibuat! Silakan cek email Anda untuk verifikasi.',
        needsEmailVerification: true,
        user: authResponse.user,
      );

    } on AuthException catch (e) {
      if (Env.isDebug) {
        print('Auth Error: ${e.message}');
      }
      
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
      if (Env.isDebug) {
        print('Database Error: ${e.message}');
      }
      
      String errorMessage = 'Gagal menyimpan data profil.';
      if (e.code == '23505') {
        errorMessage = 'Data sudah ada. Silakan gunakan data yang berbeda.';
      }
      
      return AuthResult(
        success: false,
        message: errorMessage,
      );
    } catch (e) {
      if (Env.isDebug) {
        print('General Error: $e');
      }
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
      if (Env.isDebug) {
        print('Login Error: ${e.message}');
      }
      
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
      if (Env.isDebug) {
        print('Login General Error: $e');
      }
      return AuthResult(
        success: false,
        message: 'Terjadi kesalahan: ${e.toString()}',
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
      if (Env.isDebug) {
        print('Get current pengguna error: $e');
      }
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

  // Dispose method untuk cleanup
  static void dispose() {
    _authStateController.close();
  }
}
