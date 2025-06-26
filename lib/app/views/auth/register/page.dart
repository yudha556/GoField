import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/app/views/auth/hooks/login.hooks.dart';
import 'package:gofield/core/models/pengguna_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final result = await useAuthRegister(
          context,
          email: _emailController.text.trim(),
          password: _passwordController.text,
          namaLengkap: _nameController.text.trim(),
          nomorTelepon: _phoneController.text.trim().isEmpty 
              ? null 
              : _phoneController.text.trim(),
          alamat: _addressController.text.trim().isEmpty 
              ? null 
              : _addressController.text.trim(),
          peran: PeranEnum.pengguna,
        );

        if (result.success) {
          if (mounted) {
            if (result.needsEmailVerification) {
              context.go(AppRoutes.verify);
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          setState(() {
            _errorMessage = result.message;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _handleGoogleRegister() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await useGoogleSignIn(context, isRegister: true);
      
      if (!result.success) {
        setState(() {
          _errorMessage = result.message;
        });
      }
      // Jika success, navigation sudah dihandle di hook
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mendaftar dengan Google. Silakan coba lagi.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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
          child: Form(
            key: _formKey,
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

                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],

                // Nama Lengkap
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    if (value.trim().length < 2) {
                      return 'Nama lengkap minimal 2 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),

                // Email
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),

                // Nomor Telepon (Optional)
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Nomor Telepon (Opsional)',
                    hintText: 'Masukan Nomor Telepon Anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (value.trim().length < 10) {
                        return 'Nomor telepon minimal 10 digit';
                      }
                      if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
                        return 'Format nomor telepon tidak valid';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),

                // Alamat (Optional)
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Alamat (Opsional)',
                    hintText: 'Masukan Alamat Anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (value.trim().length < 10) {
                        return 'Alamat minimal 10 karakter';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),

                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukan password anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible 
                          ? Icons.visibility 
                          : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(value)) {
                      return 'Password harus mengandung huruf dan angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    hintText: 'Masukan ulang password anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: const Icon(Icons.lock_reset),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible 
                          ? Icons.visibility 
                          : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    if (value != _passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),

                // Terms and Conditions Checkbox
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
                                  _showTermsDialog();
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // Register Button
                PrimaryButton(
                  text: _isLoading ? 'Loading...' : 'Daftar',
                  isFullWidth: true,
                  onPressed: (_agreeToTerms && !_isLoading) ? _handleRegister : null,
                ),
                const SizedBox(height: 24.0),

                // Divider
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

                // Google Sign Up Button
                Center(
                  child: InkWell(
                    onTap: _isLoading ? null : _handleGoogleRegister,
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
                      child: _isLoading 
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

                // Already have account
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
                        context.go(AppRoutes.login);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Syarat dan Ketentuan'),
        content: const SingleChildScrollView(
          child: Text(
            'Dengan menggunakan aplikasi GoField, Anda menyetujui:\n\n'
            '1. Menggunakan aplikasi sesuai dengan tujuan yang dimaksudkan\n'
            '2. Tidak menyalahgunakan layanan yang tersedia\n'
            '3. Memberikan informasi yang akurat dan terkini\n'
            '4. Menjaga kerahasiaan akun dan password Anda\n'
            '5. Mematuhi semua aturan dan regulasi yang berlaku\n\n'
            'Kami berhak menangguhkan atau menghapus akun yang melanggar ketentuan ini.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
