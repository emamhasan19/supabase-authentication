import 'package:flutter/material.dart';
import 'package:supabase_authentication/features/splash_screen.dart';
import 'package:supabase_authentication/my_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  const String supabaseUrl = 'https://kmvdamnrfrsvvetywwsw.supabase.co';
  const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImttdmRhbW5yZnJzdnZldHl3d3N3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMxMTI3NDgsImV4cCI6MjA0ODY4ODc0OH0.689rT8G0i-XgocjplN1tpzyozu2k8pAVDdeqdmcSXyA';

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const MyApp());
}
