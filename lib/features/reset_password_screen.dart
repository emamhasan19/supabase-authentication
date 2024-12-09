import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:supabase_authentication/features/sign_in_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String accessToken;

  ResetPasswordScreen({required this.accessToken});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> updateUserPassword({
    required String accessToken,
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await Dio().put(
        'https://kmvdamnrfrsvvetywwsw.supabase.co/auth/v1/user',
        data: {
          'password': newPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'apikey':
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImttdmRhbW5yZnJzdnZldHl3d3N3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMxMTI3NDgsImV4cCI6MjA0ODY4ODc0OH0.689rT8G0i-XgocjplN1tpzyozu2k8pAVDdeqdmcSXyA',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Password updated successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SignInScreen()),
        );
      } else {
        print(
            'Error updating password: ${response.statusCode} ${response.data}');
      }
      setState(() {
        _isLoading = false;
      });
    } on DioException catch (e) {
      print('DioException: ${e.response?.data}');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Unexpected error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await updateUserPassword(
                  accessToken: widget.accessToken,
                  // Extract this from the deep link
                  newPassword: _passwordController.text,
                  context: context,
                );
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
