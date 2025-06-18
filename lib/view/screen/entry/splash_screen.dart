import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:z_admin/view/screen/entry/login.dart';
import 'package:z_admin/view/screen/dashboard_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _navigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(const Duration(seconds: 3));

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use addPostFrameCallback to avoid calling async in build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate(context);
    });

    return Scaffold(
      body: Center(child: Image.asset('assets/images/logo.png')),
    );
  }
}
