import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/providers/auth_provider.dart';
import 'package:kuttot/features/shell/presentation/shell_screen.dart';

class LogoutConfirmationScreen extends ConsumerWidget {
  const LogoutConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Background Blobs (Blurred circles)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.kutootMaroon.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.locationOrange.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Back Button Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration Icon Area
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Offset Border Ring
                            Transform.rotate(
                              angle: -12 * (3.14159 / 180),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.kutootMaroon.withValues(alpha: 0.1),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            // Main Icon Circle
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHighest,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.logout,
                                color: AppColors.kutootMaroon,
                                size: 40,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),

                        // Typography
                        Text(
                          'Are you sure you want to logout?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'You will need to enter your mobile number and OTP again to access your rewards.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 56),

                        // Actions
                        GestureDetector(
                          onTap: () async {
                            await ref.read(authProvider.notifier).logout();
                            if (context.mounted) {
                              // Switch the shell's active tab to the Home tab
                              ref.read(bottomNavIndexProvider.notifier).state = 0;
                              // Pop the confirmation dialog back to the Shell
                              Navigator.popUntil(context, (route) => route.isFirst);
                            }
                          },
                          child: Container(

                            width: double.infinity,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.kutootMaroon,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.kutootMaroon.withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.logout, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Logout',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Branding Visual (Tilted food image)
                        Opacity(
                          opacity: 0.8,
                          child: Transform.rotate(
                            angle: 3 * (3.14159 / 180),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBO2ayZaGbbaD5nYUhN8T67ed_MWE3sY6BfW728eozjc22bOwRGsdseFEsvx3ZOeFYT_docea_2nWj7bbZG1H1LTGMtSsL53OSrlZjb22akkIndEg2_WZrEyBiogwEyLoKBfNvDluCwR_fpg_aEQU9wrfjzVVqv1gERxiVX5a-8J6RvoA4HpMuKL8BD0quey8W7U_DacDx1JbYCXMiNTnYBeDadj4x_Dx_Zwz8UkxeMaIyiM7M7iQqu9vPCj_6OGxKfwk_2TpjObac',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
