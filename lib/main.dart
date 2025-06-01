import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gosport/core/constants/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment variables
  await Env.init();
  
  // Print config untuk debug
  Env.printConfig();
  
  // Initialize Supabase dengan config dari Env
  if (Env.isSupabaseConfigured) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
    print('✅ Supabase initialized successfully');
  } else {
    print('❌ Supabase configuration missing');
  }
  
  runApp(const MyApp());
}

// Get a reference to Supabase client
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Env.appName,                               // ← Dari Env
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      home: MyHomePage(title: '${Env.appName} Home Page'),  // ← Dari Env
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    
    // Test environment variables dari Env class
    if (Env.isDebug) {
      print('Counter: $_counter');
      print('Supabase URL: ${Env.supabaseUrl}');
      print('App Name: ${Env.appName}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Env.appName,                               // ← Dari Env
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'with Supabase',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            if (Env.isSupabaseConfigured)               // ← Conditional dari Env
              Text(
                'Connected to: ${Env.supabaseUrl.substring(0, 30)}...',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.green[600],
                ),
              )
            else
              Text(
                'Supabase not configured',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.red[600],
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'You have pushed the button this many times:',
              style: GoogleFonts.roboto(),
            ),
            Text(
              '$_counter',
              style: GoogleFonts.roboto(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            if (Env.isDebug)                            // ← Debug info dari Env
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Debug Mode: ON',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.orange,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
