import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/app/views/auth/hooks/login.hooks.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulasi login process
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });

        // Determine role based on email or you can implement your own logic
        String role = _determineUserRole(_emailController.text);
        
        // Call the login hook to navigate to appropriate page
        useLoginHook(context, role);
      });
    }
  }

  String _determineUserRole(String email) {
    // Simple role determination based on email
    // You can replace this with actual authentication logic
    if (email.toLowerCase().contains('admin')) {
      return 'admin';
    } else if (email.toLowerCase().contains('owner')) {
      return 'owner';
    } else {
      return 'user';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('LoginPage: build called');
    return Scaffold(
      backgroundColor: Colors.white,
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
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Selamat datang di aplikasi Go Field!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 20.0),

                // Email form field
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
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),

                // Password form field
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
                    return null;
                  },
                ),
                const SizedBox(height: 5.0),

                // Forgot password button 
                Align(
                  alignment: Alignment.centerRight,
                  child: LinkButton(
                    text: 'Lupa Password?',
                    size: ButtonSize.small,
                    onPressed: () {
                      print('Forgot password pressed');
                    },
                  ),
                ),
                const SizedBox(height: 20.0),

                // Login button 
                PrimaryButton(
                  text: _isLoading ? 'Loading...' : 'Login',
                  size: ButtonSize.medium,
                  isFullWidth: true,
                  onPressed: _isLoading ? null : _handleLogin,
                ),
                const SizedBox(height: 24.0),

                Row(
                  children: <Widget>[
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'Atau Login Menggunakan',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20.0),

                // Google icon button 
                Center(
                  child: InkWell(
                    onTap: () {
                      print('Login with Google (icon only) pressed!');
                    },
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
                      child: SvgPicture.asset(
                        'assets/icons/icons-google.svg',
                        height: 24.0,
                        width: 24.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),

                // Register button 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun?',
                      style: TextStyle(color: Colors.black),
                    ),
                    LinkButton(
                      text: 'Daftar Sekarang',
                      size: ButtonSize.small,
                      onPressed: () {
                        context.go(AppRoutes.register);
                        print('Register button pressed');
                      },
                    ),
                  ],
                ),

                // Development helper text
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: const Text(
                    'Development Mode:\n'
                    '• Email dengan "admin" → Admin Dashboard\n'
                    '• Email dengan "owner" → Owner Dashboard\n'
                    '• Email lainnya → User Dashboard',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
