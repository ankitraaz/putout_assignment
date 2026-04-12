import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/providers/location_provider.dart';
import 'package:kuttot/features/home/presentation/widgets/location_search_sheet.dart';
import 'package:kuttot/features/subscriptions/presentation/subscription_screen.dart';
import 'package:kuttot/features/shell/presentation/shell_screen.dart';

class AppHeader extends ConsumerWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationProvider);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
          ),
          child: SafeArea(
            bottom: false,
            child: Container(
              height: 64, // Consistent 64px content height
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                alignment: Alignment.center,
                children: [
          // Left: Location Pill
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const LocationSearchSheet(),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E6), // Light orange background
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.locationOrange,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      locationAsync.when(
                        data: (location) => location.length > 12
                            ? '${location.substring(0, 9)}...'
                            : location,
                        loading: () => 'LOCATING...',
                        error: (_, __) => 'MUMBAI',
                      ),
                      style: const TextStyle(
                        color: AppColors.locationOrange,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.locationOrange,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Center: Logo Image
          Image.asset(
            'assets/images/screen.png',
            height: 48,
            fit: BoxFit.contain,
          ),

          // Right: Upgrade Button
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.kutootRed,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kutootRed.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size(0, 32),
                ),
                child: const Text(
                  'UPGRADE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
