import 'package:flutter/material.dart';
import 'package:supabase_authentication/features/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email; // Pass the email used for signup

  const OTPVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        token: _otpController.text,
        type: OtpType.signup,
        email: widget.email,
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account verified successfully!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomeScreen()), // Navigate to HomeScreen directly
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error verifying OTP: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter the OTP sent to your email',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOTP,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
