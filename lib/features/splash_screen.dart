import 'package:flutter/material.dart';
import 'package:supabase_authentication/features/sign_in_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security_rounded,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            Text(
              'Supabase Authentication',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ), // Optional loading indicator
          ],
        ),
      ),
    );
  }
}
