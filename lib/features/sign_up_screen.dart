import 'package:flutter/material.dart';
import 'package:supabase_authentication/features/otp_verification_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signUp() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (response.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OTPVerificationScreen(email: _emailController.text),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  _isLoading ? null : _signUp();
                },
                child: _isLoading
                    ? CircularProgressIndicator()
                    : const Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
