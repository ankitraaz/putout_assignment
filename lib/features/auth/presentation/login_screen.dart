import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/providers/auth_provider.dart';
import 'package:kuttot/features/auth/presentation/otp_screen.dart';
import 'package:kuttot/features/auth/presentation/need_help_screen.dart';
import 'package:kuttot/features/auth/presentation/widgets/privacy_policy_sheet.dart';
import 'package:kuttot/features/auth/presentation/widgets/terms_conditions_sheet.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  bool _isValid = false;
  bool _showLoader = false;

  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void _validatePhone() {
    setState(() {
      _isValid = _phoneController.text.length == 10;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (!_isValid) return;
    final phone = _phoneController.text.trim();

    // Show glassmorphic loader
    setState(() => _showLoader = true);

    await ref.read(authProvider.notifier).sendOtp(phone);

    if (mounted) {
      setState(() => _showLoader = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpScreen(phone: phone)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // ── Main Login Content ──
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with logo
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/k.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          'assets/images/screen.png',
                          height: 22,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Logo Circle with soft glow
                  Center(
                    child: SizedBox(
                      width: 132,
                      height: 132,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow
                          Container(
                            width: 132,
                            height: 132,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.kutootRed.withValues(
                                alpha: 0.08,
                              ),
                            ),
                          ),
                          // White circle with logo
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.asset(
                                  'assets/images/k.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Welcome Text
                  Center(
                    child: Text(
                      'Welcome',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Future of local commerce',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Mobile Number Label
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      'MOBILE NUMBER',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Phone Input Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFF5E5DB,
                        ), // surface-container-high
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          // India Flag
                          const Text('🇮🇳', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          // Divider line
                          Container(
                            width: 1,
                            height: 24,
                            color: AppColors.surfaceContainerHighest.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '+91',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                                hintText: '00000 00000',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textLight,
                                ),
                                filled: false,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_isValid)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.kutootRed,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Log In Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: _showLoader ? null : _onLogin,
                      child: Container(
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: _isValid
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF8A002B),
                                    Color(0xFFAE1E3F),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: _isValid
                              ? null
                              : AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            999,
                          ), // full rounded
                          boxShadow: _isValid
                              ? [
                                  BoxShadow(
                                    color: AppColors.kutootRed.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log In',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _isValid
                                    ? Colors.white
                                    : AppColors.textLight,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color: _isValid
                                  ? Colors.white
                                  : AppColors.textLight,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Terms & Conditions
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By continuing, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  TermsConditionsSheet.show(context);
                                },
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.kutootRed,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  PrivacyPolicySheet.show(context);
                                },
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.kutootRed,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Need Help
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NeedHelpScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.contact_support_outlined,
                            size: 16,
                            color: AppColors.kutootRed,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Need Help?',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.kutootRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Visual Embellishment (Zomato-esque Asymmetry)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32), // px-8
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 128,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                // Background Image with opacity
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.4,
                                    child: Image.network(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuC06zacuaFHV7P-wH411KFYqyKJLIK0XTTeAP70OfLWmymHrVRqEho2VwUnxu-YmebUZ6JL7TjRvtZKOciLBQxYoIpQSbhZTUSS3DPjqUMiRR2BlqWNHqpWQSGEfaPI7ONZpThLHdM08wgJVC5X8bPg9JHy9os-qRvLTV7IBad7zfsX5FkOgV_dIfN9dDlphX7MQwsMWAPkHyFsa28eLv5RfTb59hu8IUJIEx0CnEGXHm_IilrRBycwlH1MEv_nDW5ky4im2vCWiw',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Gradient Overlay
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          AppColors.surfaceContainerLow,
                                          AppColors.surfaceContainerLow
                                              .withValues(alpha: 0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Text
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  child: Text(
                                    'FRESH DELIVERY',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                      color: AppColors.kutootRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16), // gap-4 is 16px
                        Expanded(
                          child: Transform.translate(
                            offset: const Offset(0, 16), // translate-y-4
                            child: Container(
                              height: 128,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                children: [
                                  // Background Image with opacity
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.4,
                                      child: Image.network(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBqkzOJPr5UReWxGrO2BEWCe3xlo3mvrfsq8iHPYHw7dXg5Y9p0plNjKz3nWvVj5wSOHMyow74dzd_wBD1_539E6nH0zloIxyI8HQb4brpaAzFHpuvpw8I5qM-itOTIIdPnctJM12I0tHkwDb50QN1skba1AwF4S4df5xUaQVBdSYmexjdZU-RhhIOjj-kTSeSqPkCZMW4h4-EfGc9QASpdoCk0nsW8ayqpcoJ73qisTL5Go1ClurvKZo72UidlkwqVLP16O72kZQ',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Gradient Overlay
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            AppColors.surfaceContainerLow,
                                            AppColors.surfaceContainerLow
                                                .withValues(alpha: 0.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Text
                                  Positioned(
                                    bottom: 12,
                                    left: 12,
                                    child: Text(
                                      'LOCAL SHOPS',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.2,
                                        color: AppColors.kutootRed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),

          // ── Glassmorphic Loading Overlay ──
          if (_showLoader) _LoadingOverlay(spinController: _spinController),
        ],
      ),
    );
  }
}

/// Full-screen glassmorphic loading overlay
class _LoadingOverlay extends StatelessWidget {
  final AnimationController spinController;

  const _LoadingOverlay({required this.spinController});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          color: AppColors.scaffoldBg.withValues(alpha: 0.8),
          child: Stack(
            children: [
              // Decorative blurs
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 256,
                  height: 256,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.kutootRed.withValues(alpha: 0.04),
                  ),
                ),
              ),
              Positioned(
                bottom: -128,
                left: -128,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.locationOrange.withValues(alpha: 0.04),
                  ),
                ),
              ),

              // Center content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Circular spinner with logo
                    SizedBox(
                      width: 128,
                      height: 128,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer track
                          Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.kutootRed.withValues(
                                  alpha: 0.1,
                                ),
                                width: 4,
                              ),
                            ),
                          ),
                          // Animated arc spinner
                          AnimatedBuilder(
                            animation: spinController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: spinController.value * 2 * math.pi,
                                child: CustomPaint(
                                  size: const Size(128, 128),
                                  painter: _SpinnerPainter(),
                                ),
                              );
                            },
                          ),
                          // Center logo
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                'assets/images/k.png',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Loading text
                    Text(
                      'Curating your experience',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Animated dots
                    const _AnimatedDots(),

                    const SizedBox(height: 48),

                    // Quote
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        '"Gastronomy is the intelligent knowledge of whatever concerns man\'s nourishment."',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the spinning arc
class _SpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.kutootRed
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    canvas.drawArc(rect, 0, math.pi * 0.8, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Three pulsing dots
class _AnimatedDots extends StatefulWidget {
  const _AnimatedDots();

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final opacity = 0.2 + 0.6 * math.sin(value * math.pi);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.kutootRed.withValues(alpha: opacity),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
