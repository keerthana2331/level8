// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShoppingHomePage extends StatelessWidget {
  const ShoppingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: CurvedBackgroundPainter(),
            ),
          ),
          buildFloatingShapes(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Spacer(),
                buildMainContent(context),
                const Spacer(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMainContent(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 1),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Column(
              children: [
                buildLogoSection(),
                const SizedBox(height: 60),
                buildAuthButtons(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildLogoSection() {
    return Column(
      children: [
        TweenAnimationBuilder(
          duration: const Duration(seconds: 1),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent.withOpacity(0.4),
                          Colors.redAccent.withOpacity(0.4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(70),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.3),
                          blurRadius: 25,
                          offset: const Offset(5, 5),
                        ),
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 25,
                          offset: const Offset(-5, -5),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.shopping_basket,
                    size: 60,
                    color: Colors.deepOrange,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 30),
        const Text(
          'SHOPPING CART',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
            color: Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  Widget buildAuthButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          buildButton(
            onTap: () => Navigator.pushNamed(context, '/signup'),
            text: 'Create Account',
            isPrimary: true,
          ),
          const SizedBox(height: 15),
          buildButton(
            onTap: () => Navigator.pushNamed(context, '/login'),
            text: 'Sign In',
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  Widget buildButton({
    required VoidCallback onTap,
    required String text,
    required bool isPrimary,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: isPrimary ? const Color(0xFF6C63FF) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isPrimary
                ? null
                : Border.all(color: const Color(0xFF6C63FF), width: 2),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isPrimary ? Colors.white : const Color(0xFF6C63FF),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFloatingShapes() {
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 20),
      tween: Tween<double>(begin: 0, end: 2 * math.pi),
      builder: (context, double value, child) {
        return Transform.rotate(
          angle: value,
          child: CustomPaint(
            painter: FloatingShapesPainter(),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class CurvedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFF8F9FA),
          Colors.white.withOpacity(0.9),
          const Color(0xFFF1F2F6),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    final curvePaint = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final curvePath = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.2,
        size.width,
        size.height * 0.4,
      );

    canvas.drawPath(curvePath, curvePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FloatingShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 20 + 10;

      paint.color = Color(0xFF6C63FF).withOpacity(0.05);

      if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      } else if (i % 3 == 1) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y),
            width: radius * 2,
            height: radius * 2,
          ),
          paint,
        );
      } else {
        final path = Path()
          ..moveTo(x, y - radius)
          ..lineTo(x + radius, y + radius)
          ..lineTo(x - radius, y + radius)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
