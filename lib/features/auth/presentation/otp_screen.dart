import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/providers/auth_provider.dart';
import 'package:kuttot/core/providers/profile_provider.dart';
import 'package:kuttot/features/auth/presentation/need_help_screen.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-fill OTP for demo purposes after a short delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        final authState = ref.read(authProvider);
        if (authState.otp != null) {
          _autoFillOtp(authState.otp!);
        }
      }
    });
  }

  void _autoFillOtp(String otp) {
    // Fill the OTP digits into the fields
    for (int i = 0; i < otp.length && i < 6; i++) {
      _controllers[i].text = otp[i];
    }
    setState(() {});
  }

  void _startTimer() {
    _secondsLeft = 30;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredOtp =>
      _controllers.map((c) => c.text).join();

  bool get _isOtpComplete => _enteredOtp.length >= 4;

  void _onVerify() async {
    if (!_isOtpComplete) return;
    final success = await ref.read(authProvider.notifier).verifyOtp(_enteredOtp);
    if (mounted && success) {
      // Force reload the profile so it picks up the correct phone and data from SharedPreferences natively
      await ref.read(profileProvider.notifier).loadProfile();
      
      // Pop all auth screens and go to shell
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (mounted) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid OTP. Try: ${ref.read(authProvider).otp}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.kutootRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _onResend() async {
    if (!_canResend) return;
    await ref.read(authProvider.notifier).resendOtp();
    _startTimer();
    // Clear fields
    for (final c in _controllers) {
      c.clear();
    }
    if (mounted) {
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/screen.png',
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // balance
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Verify your number',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle with Edit
                    Row(
                      children: [
                        Text(
                          'OTP sent to +91${widget.phone}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Edit',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.kutootRed,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // OTP Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 48,
                          height: 52,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: _controllers[index].text.isNotEmpty
                                  ? const Color(0xFFF5E5DB)
                                  : const Color(0xFFF5E5DB).withValues(alpha: 0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: AppColors.kutootRed,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              }
                              if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                              setState(() {});
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    // Resend OTP
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Didn't receive code? ",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: _canResend ? _onResend : null,
                            child: Text(
                              'Resend OTP',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: _canResend
                                    ? AppColors.kutootRed
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (!_canResend)
                            Text(
                              ' in 0:${_secondsLeft.toString().padLeft(2, '0')}s',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Verify & Proceed Button
                    GestureDetector(
                      onTap: isLoading ? null : _onVerify,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: _isOtpComplete
                              ? const LinearGradient(
                                  colors: [Color(0xFF8A002B), Color(0xFFAE1E3F)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: _isOtpComplete ? null : AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: _isOtpComplete
                              ? [
                                  BoxShadow(
                                    color: AppColors.kutootRed.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Verify & Proceed',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: _isOtpComplete
                                        ? Colors.white
                                        : AppColors.textLight,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Need Help
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NeedHelpScreen(phone: widget.phone),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'Need Help?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
