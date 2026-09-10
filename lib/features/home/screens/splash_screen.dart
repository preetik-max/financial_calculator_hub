import 'dart:async';

import 'package:flutter/material.dart';

import 'package:financial_calculator_hub/app/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    Timer(const Duration(milliseconds: 2800), _openHome);
  }

  void _openHome() {
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1F3A),
              Color(0xFF173F67),
              Color(0xFF176B72),
              Color(0xFF0E8F70),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ---------------------------------------------------------
                    // Logo
                    // ---------------------------------------------------------
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.20),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 64,
                          color: Color(0xFF176B72),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ---------------------------------------------------------
                    // App Name
                    // ---------------------------------------------------------
                    const Text(
                      'Financial',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),

                    const Text(
                      'Calculator Hub',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ---------------------------------------------------------
                    // Motto
                    // ---------------------------------------------------------
                    const Text(
                      'Plan Smart. Calculate Better.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Grow Better.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFB8FFE8),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),

                    const SizedBox(height: 55),

                    // ---------------------------------------------------------
                    // Loading indicator
                    // ---------------------------------------------------------
                    SizedBox(
                      width: 34,
                      height: 34,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Preparing your calculators...',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
