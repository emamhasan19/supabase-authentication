import 'package:flutter/material.dart';
import 'package:supabase_authentication/features/forget_password_screen.dart';
import 'package:supabase_authentication/features/home_screen.dart';
import 'package:supabase_authentication/features/sign_up_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signed in successfully!')));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
      setState(() {
        _isLoading = false;
      });
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
      appBar: AppBar(title: const Text('Sign In')),
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
                  _isLoading ? null : _signIn();
                },
                child: _isLoading
                    ? CircularProgressIndicator()
                    : const Text('Sign In')),
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUpScreen())),
              child: const Text('Sign Up'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen())),
              child: const Text('Forgot Password'),
            ),
          ],
        ),
      ),
    );
  }
}
