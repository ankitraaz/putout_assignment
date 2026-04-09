import 'package:flutter/material.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          gradient: AppColors.bannerGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.bannerDarkRed.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // ── SALE. ── Large transparent, horizontally CENTERED
            Positioned(
              left: 0,
              right: 0,
              top: 68,
              child: Center(
                child: Transform.translate(
                  offset: const Offset(20, 0), // Shift right so S clears Safhion's tail
                  child: Text(
                    'SALE.',
                    style: GoogleFonts.oswald(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 62,
                      height: 1.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                  ),
                ),
              ),
            ),

            // ── Safhion ── Cursive, horizontally CENTERED
            Positioned(
              left: 0,
              right: 0,
              top: 30,
              child: Center(
                child: Text(
                  'Safhion',
                  style: GoogleFonts.greatVibes(
                    color: Colors.white,
                    fontSize: 62,
                    height: 1.0,
                  ),
                ),
              ),
            ),

            // ── FASHINEON ™ ── Slightly RIGHT of center, above Safhion, no touch
            Positioned(
              left: 0,
              right: 0,
              top: 12,
              child: Center(
                child: Transform.translate(
                  offset: const Offset(30, 0), // Slightly right of center, no overlap with Safhion
                  child: Text(
                    'FASHIN EON ™',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),

            // ── Bottom Left: FASHION FIESTA + Upto 70% Off ──
            Positioned(
              left: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    color: const Color(0xFFD3A300),
                    child: Text(
                      'FASHION FIESTA',
                      style: GoogleFonts.oswald(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Upto 70% Off',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
