import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _dotOpacity;
  late Animation<double> _progressWidth;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _logoOpacity = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _dotOpacity = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController, 
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();

    _progressWidth = Tween<double>(begin: 0.0, end: 0.35).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Navigate after splash animation
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),
      body: Stack(
        children: [
          // Background Subtle Radial Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFDADB).withValues(alpha: 0.2), // primary-fixed
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7],
                  radius: 1.2,
                ),
              ),
            ),
          ),
          
          // Centerpiece Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B322B).withValues(alpha: 0.15),
                          blurRadius: 64,
                          offset: const Offset(0, 32),
                          spreadRadius: -12,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/k_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Branding Wordmark
                Image.asset(
                  'assets/images/screen.png',
                  height: 48,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback in case screen.png fails
                    return Image.asset(
                      'assets/images/kutoot_wordmark.png',
                      height: 48,
                      fit: BoxFit.contain,
                    );
                  },
                ),
                const SizedBox(height: 8),
                
                // Tagline
                Text(
                  'THE CULINARY CURATOR',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.4, // CSS tracking-[0.2em]
                    color: const Color(0xFF594042),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Loading & Status
          Positioned(
            bottom: 64,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: SizedBox(
                  width: 320,
                  child: Column(
                    children: [
                      // Status Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _dotOpacity.value,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFA04100), // secondary
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Fetching your location...',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF594042),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Linear Progress Bar
                      Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFE0D5), // surface-container-highest
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progressWidth.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8A002B), // primary
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
