import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:supabase_authentication/features/sign_in_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String supabaseUrl =
      "https://kmvdamnrfrsvvetywwsw.supabase.co/auth/v1/recover";
  String supabaseAnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImttdmRhbW5yZnJzdnZldHl3d3N3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMxMTI3NDgsImV4cCI6MjA0ODY4ODc0OH0.689rT8G0i-XgocjplN1tpzyozu2k8pAVDdeqdmcSXyA";

  Future<void> _sendPasswordResetEmail() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await Dio().post(
        supabaseUrl,
        data: {
          'email': _emailController.text,
          'type': 'recovery',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $supabaseAnonKey',
            'apiKey': supabaseAnonKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent!')));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to send OTP: ${response.statusCode}")));
      }
      setState(() {
        _isLoading = false;
      });
    } on DioException catch (dioError) {
      setState(() {
        _isLoading = false;
      });
      final errorResponse = dioError.response?.data;
      final errorMessage = errorResponse is Map<String, dynamic> &&
              errorResponse.containsKey('msg')
          ? errorResponse['msg']
          : dioError.message;
      print("DioException: $errorMessage");
    } catch (e) {
      setState(() {
        _isLoading = true;
      });
      print("Unexpected Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  _isLoading ? null : _sendPasswordResetEmail();
                },
                child: _isLoading
                    ? CircularProgressIndicator()
                    : const Text('Send Reset Email')),
          ],
        ),
      ),
    );
  }
}
