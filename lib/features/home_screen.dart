import 'package:flutter/material.dart';
import 'package:supabase_authentication/features/sign_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  Future<void> _signOut(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Supabase.instance.client.auth.signOut();
      // Navigate back to the sign-in screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const SignInScreen()), // Navigate to HomeScreen directly
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the App!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (user?.email != null)
                Text(
                  'Logged in as: ${user!.email}',
                  style: const TextStyle(fontSize: 18),
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _isLoading ? null : _signOut(context);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: _isLoading
                    ? CircularProgressIndicator()
                    : const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
