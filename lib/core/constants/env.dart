import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // Private constructor
  Env._();
  
  // Initialize environment variables
  static Future<void> init() async {
    await dotenv.load(fileName: ".env.local");
  }
  
  // Supabase configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANONKEY'] ?? '';
  
  // App configuration
  static String get appName => dotenv.env['APP_NAME'] ?? 'GoSport';
  static bool get isDebug => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  
  // Hapus bagian API jika tidak dipakai
  // static String get apiUrl => dotenv.env['API_URL'] ?? '';
  // static String get apiKey => dotenv.env['API_KEY'] ?? '';
  
  // Helper method untuk validasi
  static bool get isSupabaseConfigured => 
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  
  // Method untuk print semua config (hanya untuk debug)
  static void printConfig() {
    if (isDebug) {
      print('=== Environment Configuration ===');
      print('App Name: $appName');
      print('Supabase URL: ${supabaseUrl.isNotEmpty ? "${supabaseUrl.substring(0, 30)}..." : "Not set"}');
      print('Supabase Key: ${supabaseAnonKey.isNotEmpty ? "Set" : "Not set"}');
      print('Debug Mode: $isDebug');
      print('================================');
    }
  }
}
