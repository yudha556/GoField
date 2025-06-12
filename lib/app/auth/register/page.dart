import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart'; 
import 'package:flutter/gestures.dart'; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('RegisterPage: build called');
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
                        style: const TextStyle(color: Colors.black, fontSize: 14),
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

              // --- Tombol Daftar ---
              ElevatedButton(
                onPressed: () {
                  // TODO: Tambahkan logika pendaftaran di sini
                  print('Register button pressed!');
                  print('Nama: ${_nameController.text}');
                  print('Email: ${_emailController.text}');
                  print('Password: ${_passwordController.text}');
                  print('Konfirmasi Password: ${_confirmPasswordController.text}');
                  print('Setuju S&K: $_agreeToTerms');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Daftar',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
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

              // --- Google Icon ---
              Center(
                child: InkWell(
                  onTap: () {
                    print('Register with Google (icon only) pressed!');
                  },
                  borderRadius: BorderRadius.circular(28.0),
                  child: Container(
                    width: 46.0,
                    height: 46.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/icons/icons-google.svg', 
                      height: 20.0,
                      width: 20.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              // --- Sudah punya akun? Sign In ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun?',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      print('Sign In button pressed!');
                      context.goNamed(AppRoutes.login);
                    },
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
        title: const Text('Syarat dan Ketentuan', style: TextStyle(color: Colors.black)),
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