import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuttot/features/auth/presentation/login_screen.dart';

class GuestLoginPill extends StatelessWidget {
  const GuestLoginPill({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5), // Spacing from top SafeArea and AppHeader
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3), // Light grey matching the image
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF635B5B), // Dark grey icon background
              ),
              padding: const EdgeInsets.all(3),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 10,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'GUEST • LOGIN',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF333333),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
