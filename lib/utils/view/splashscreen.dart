import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nde_crm/features/crm_home/home_screen.dart';
import 'package:nde_crm/features/login/view/login_screen.dart';
import 'package:nde_crm/utils/view/carousel_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    log("🔹 SplashScreen: Starting navigation delay...");
    final prefs = await SharedPreferences.getInstance();

    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final bool isFirstOpen = prefs.getBool('isFirstOpen') ?? true;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) {
      log("❌ SplashScreen: Widget not mounted, stopping navigation");
      return;
    }

    if (isFirstOpen) {
      await prefs.setBool('isFirstOpen', false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CarouselScreen()),
        (route) => false,
      );
    } else if (isLoggedIn) {
      log("✅ Not first time & user is logged in -> Navigating to HomeScreen");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      log(
        "ℹ️ Not first time & user NOT logged in -> Navigating to LoginScreen",
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }

  //pavi@iaaxin.com
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Centered GIF Image
            Center(
              child: Image.asset(
                "assets/images/splashscreen.gif",
                fit: BoxFit.contain,
                height: size.height * 0.3,
                width: size.width * 0.5,
              ),
            ),

            // Bottom Text
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "NDE CRM",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
