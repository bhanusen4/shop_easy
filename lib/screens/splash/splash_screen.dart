import 'dart:ui';

import 'package:ecommerce/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  void dispose() {
    controller.dispose(); // Always dispose controllers!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Animation<double> scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: controller,
          child: ScaleTransition(
            scale: scaleAnimation,
            child:  Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo/app_logo.png' ),

                // Text(
                //   "ShopEasy",
                //   style: TextStyle(
                //     fontSize: 32,
                //     fontWeight: FontWeight.w900,
                //     color: AppColors.primary,
                //     letterSpacing: 1.5,
                //   ),
               // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
