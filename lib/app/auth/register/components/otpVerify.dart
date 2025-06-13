import 'package:flutter/material.dart';
import 'package:gofield/core/components/components.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  static const int otpLength = 4;
  static const int resendDuration = 60;

  final List<TextEditingController> _otpControllers = List.generate(
    otpLength,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    otpLength,
    (index) => FocusNode(),
  );

  bool _isLoading = false;
  bool _canResend = true;
  int _resendCountdown = 0;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((controller) => controller.text).join();
  bool get _isOTPComplete => _otpCode.length == otpLength;

  void _startResendCountdown() {
    setState(() {
      _canResend = false;
      _resendCountdown = resendDuration;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _resendCountdown--);
        return _resendCountdown > 0;
      }
      return false;
    }).then((_) {
      if (mounted) {
        setState(() => _canResend = true);
      }
    });
  }

  Future<void> _handleVerification() async {
    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      // TODO: Implement actual verification logic
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleOTPFieldChange(String value, int index) {
    setState(() {});
    
    if (value.length == 1 && index < otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    } else if (index == otpLength - 1) {
      _focusNodes[index].unfocus();
    }
  }

  Widget _buildOTPField(int index) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        onChanged: (value) => _handleOTPFieldChange(value, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Verifikasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                'Masukan kode yang anda terima di email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 23.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(otpLength, _buildOTPField),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: _canResend
                    ? LinkButton(
                        text: 'Tidak menerima OTP?',
                        size: ButtonSize.small,
                        onPressed: _startResendCountdown,
                      )
                    : Text(
                        'Kirim ulang dalam $_resendCountdown detik',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
              const SizedBox(height: 10.0),
              PrimaryButton(
                text: 'Verifikasi',
                isFullWidth: true,
                isLoading: _isLoading,
                onPressed: _isOTPComplete && !_isLoading ? _handleVerification : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}