import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/models/pengguna_model.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/services/auth_service/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _agreeToTerms = false;
  bool _isGoogleLoading = false;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    
    _authSubscription = AuthService.authStateChanges.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      if (event == AuthChangeEvent.signedIn && session != null && _isGoogleLoading) {
        _handleGoogleCallback();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Handle Google OAuth callback
  Future<void> _handleGoogleCallback() async {
    try {
      final result = await AuthService.handleGoogleCallback(
        peran: PeranEnum.pengguna,
        isSignUp: true, 
      );

      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: result.success ? Colors.green : Colors.red,
          ),
        );

        if (result.success) {
          context.go(AppRoutes.userDashboard);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Method untuk handle Google Sign-Up
  Future<void> _handleGoogleSignUp() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui Syarat dan Ketentuan terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Menunggu proses Google Sign-In...'),
              SizedBox(height: 8),
              Text(
                'Aplikasi akan membuka browser. Silakan login dengan akun Google Anda.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

      final result = await AuthService.signUpWithGoogle(
        peran: PeranEnum.pengguna,
      );

      // Hide loading dialog
      if (mounted) Navigator.of(context).pop();

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
          ),
        );

        context.go(AppRoutes.userDashboard); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Daftar Akun Baru',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Silakan isi detail akun Anda',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 20.0),

              // --- Form Input Nama ---
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukan Nama Lengkap Anda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 10.0),

              // --- Form Input Email ---
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukan Email Anda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10.0),

              // --- Form Input Password ---
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Masukan password anda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: const Icon(Icons.visibility_off),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10.0),

              // --- Form Input Confirm Password ---
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  hintText: 'Masukan ulang password anda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: const Icon(Icons.visibility_off),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20.0),

              // --- Checkbox & Terms and Conditions ---
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _agreeToTerms = newValue ?? false;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Saya menyetujui ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Syarat dan Ketentuan',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Terms and Conditions clicked!');
                                // context.pushNamed(AppRoutes.termsAndConditions);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // --- Tombol Daftar 
              PrimaryButton(
                text: 'Daftar',
                isFullWidth: true,
                isLoading: false, // You can add loading state here
                onPressed: _agreeToTerms ? () async {
                  final nama = _nameController.text.trim();
                  final email = _emailController.text.trim();
                  final password = _passwordController.text;
                  final konfirmasiPassword = _confirmPasswordController.text;

                  // Validation
                  if (nama.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nama lengkap tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (email.isEmpty || !email.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email tidak valid'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (password.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password minimal 6 karakter'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (password != konfirmasiPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password tidak cocok'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    // Show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    final result = await AuthService.signUpWithEmailPassword(
                      email: email,
                      password: password,
                      namaLengkap: nama,
                      peran: PeranEnum.pengguna,
                    );

                    // Hide loading
                    Navigator.of(context).pop();

                    if (result.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.message),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Navigate to verification page
                      context.go(AppRoutes.verify);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    // Hide loading if still showing
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } : null,
              ),
              const SizedBox(height: 24.0),

              // --- Pembatas "Atau" ---
              Row(
                children: <Widget>[
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Atau Daftar Menggunakan',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20.0),

              // --- Google Icon Button (Updated) ---
              Center(
                child: InkWell(
                  onTap: _isGoogleLoading ? null : _handleGoogleSignUp,
                  borderRadius: BorderRadius.circular(28.0),
                  child: Container(
                    width: 56.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!, width: 1.5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: _isGoogleLoading
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : SvgPicture.asset(
                            'assets/icons/icons-google.svg',
                            height: 24.0,
                            width: 24.0,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              // --- Sudah punya akun? Sign In 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun?',
                    style: TextStyle(color: Colors.black),
                  ),
                  LinkButton(
                    text: 'Masuk',
                    size: ButtonSize.small,
                    onPressed: () {
                      print('Sign In button pressed!');
                      context.go(AppRoutes.login);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Placeholder untuk halaman Terms and Conditions ---
class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Syarat dan Ketentuan',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Syarat dan Ketentuan Aplikasi Go Field:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. Pengantar:\n   Selamat datang di Go Field. Dengan menggunakan aplikasi ini, Anda setuju untuk terikat oleh syarat dan ketentuan berikut. Harap baca dengan seksama sebelum menggunakan aplikasi.\n\n'
              '2. Penggunaan Aplikasi:\n   Aplikasi ini dirancang untuk tujuan manajemen lapangan. Penggunaan yang tidak sah dilarang keras.\n\n'
              '3. Privasi:\n   Data pribadi Anda akan dilindungi sesuai dengan kebijakan privasi kami. Detail lebih lanjut dapat ditemukan di halaman Kebijakan Privasi kami.\n\n'
              '4. Tanggung Jawab Pengguna:\n   Anda bertanggung jawab penuh atas aktivitas yang dilakukan melalui akun Anda.\n\n'
              '5. Perubahan Syarat dan Ketentuan:\n   Kami berhak mengubah syarat dan ketentuan ini kapan saja. Perubahan akan berlaku segera setelah diposting di aplikasi.\n\n'
              '6. Kontak:\n   Untuk pertanyaan lebih lanjut, silakan hubungi kami melalui support@gofield.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}