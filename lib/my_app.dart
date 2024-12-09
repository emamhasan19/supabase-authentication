import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_authentication/features/reset_password_screen.dart';
import 'package:supabase_authentication/features/splash_screen.dart';
import 'package:supabase_authentication/services/navigation_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initDeepLink();
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLink() async {
    _appLinks = AppLinks();

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        final fragment = uri.fragment;
        if (fragment.isNotEmpty) {
          final fragmentParameters = Uri.splitQueryString(fragment);

          final accessToken = fragmentParameters['access_token'];
          final type = fragmentParameters['type'];

          if (accessToken != null && type == 'recovery') {
            print('Access Token: $accessToken');
            print('Type: $type');
            if (context.mounted) {
              NavigationService()
                  .navigateTo(ResetPasswordScreen(accessToken: accessToken));
            }
          } else {
            print('Invalid recovery link or missing parameters.');
          }
        } else {
          print('Fragment is empty.');
        }
      } else {
        print('URI is null.');
      }
    });

    // Handle links
    // _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
    //   final queryParameters = uri.queryParameters;
    //   final accessToken = queryParameters['access_token'];
    //   final type = queryParameters['type'];
    //
    //   if (type == 'recovery' && accessToken != null) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => ResetPasswordScreen(accessToken: accessToken),
    //       ),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Auth',
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorKey: NavigationService().navigatorKey,
      home: const SplashScreen(),
    );
  }
}
