import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();
  
  // Initialize environment variables
  static Future<void> init() async {
    await dotenv.load(fileName: ".env.local");
  }
  
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANONKEY'] ?? '';
  
  static String get appName => dotenv.env['APP_NAME'] ?? 'GoSport';
  static bool get isDebug => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  
  static bool get isSupabaseConfigured => 
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

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
