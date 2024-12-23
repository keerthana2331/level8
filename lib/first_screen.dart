import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'dart:math' as math;

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                AlwaysStoppedAnimation(0),
              ]),
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: OrbsPainter(
                      DateTime.now().millisecondsSinceEpoch % 10000 / 10000),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Expanded(
                    child: buildMainContent(context),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMainContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLogo(),
        SizedBox(height: 50),
        buildAuthButtons(context),
      ],
    );
  }

  Widget buildLogo() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 2,
            ),
          ),
          child: Icon(
            IconlyBold.bag_2,
            size: 50,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'SHOPPING CART',
          style: GoogleFonts.syncopate(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 8,
          ),
        ).animate().fadeIn().slideY(begin: 0.3).then().shimmer(delay: 400.ms),
      ],
    );
  }

  Widget buildAuthButtons(BuildContext context) {
    return Column(
      children: [
        buildPrimaryButton(
          'Create Account',
          IconlyBold.add_user,
          [Color(0xFF8A2BE2), Color(0xFF4B0082)],
          () => Navigator.pushNamed(context, '/signup'),
        ),
        SizedBox(height: 15),
        buildSecondaryButton(
          'LOGIN',
          IconlyBold.login,
          () => Navigator.pushNamed(context, '/login'),
        ),
      ],
    );
  }

  Widget buildPrimaryButton(
      String text, IconData icon, List<Color> colors, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn()
        .slideX(begin: -0.2, end: 0)
        .then()
        .shimmer(delay: 2.seconds);
  }

  Widget buildSecondaryButton(
      String text, IconData icon, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2, end: 0);
  }
}

class OrbsPainter extends CustomPainter {
  final double animation;

  OrbsPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    void drawOrb(double x, double y, Color color, double radius) {
      final gradient = RadialGradient(
        colors: [
          color.withOpacity(0.3),
          color.withOpacity(0),
        ],
      );

      final rect = Rect.fromCircle(
        center: Offset(x, y),
        radius: radius,
      );

      paint.shader = gradient.createShader(rect);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    drawOrb(
      size.width * (0.5 + math.cos(animation * 2 * math.pi) * 0.2),
      size.height * (0.3 + math.sin(animation * 2 * math.pi) * 0.1),
      Colors.purple,
      size.width * 0.4,
    );

    drawOrb(
      size.width * (0.5 + math.cos((animation + 0.4) * 2 * math.pi) * 0.2),
      size.height * (0.6 + math.sin((animation + 0.4) * 2 * math.pi) * 0.1),
      Colors.blue,
      size.width * 0.3,
    );
  }

  @override
  bool shouldRepaint(OrbsPainter oldDelegate) => true;
}
