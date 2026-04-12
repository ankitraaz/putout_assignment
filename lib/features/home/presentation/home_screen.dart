import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/constants/app_strings.dart';
import 'package:kuttot/core/providers/app_providers.dart';
import 'package:kuttot/core/providers/auth_provider.dart';

import 'package:kuttot/core/widgets/app_header.dart';
import 'package:kuttot/core/widgets/custom_search_bar.dart';
import 'package:kuttot/features/home/presentation/widgets/banner_card.dart';
import 'package:kuttot/features/home/presentation/widgets/category_row.dart';
import 'package:kuttot/features/home/presentation/widgets/guest_login_pill.dart';
import 'package:kuttot/features/home/presentation/widgets/section_header.dart';
import 'package:kuttot/features/home/presentation/widgets/store_card.dart';

import 'package:kuttot/features/shell/presentation/shell_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isGuest = authState.status != AuthStatus.authenticated;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isGuest)
                const Padding(
                  padding: EdgeInsets.only(left: 24, top: 4),
                  child: GuestLoginPill(),
                ),

              // ── Header ──
              Padding(
                padding: EdgeInsets.only(top: isGuest ? 8 : 16),
                child: const AppHeader(),
              ),

              const SizedBox(height: 16), // mt-4 for search


              // ── Search ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomSearchBar(
                  hintText: AppStrings.searchHint,
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                ),
              ),

              const SizedBox(height: 24), // mt-6

              // ── Banner ──
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: BannerCard(),
              ),

              const SizedBox(height: 32), // mt-8


              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'DISCOVER CATEGORIES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const CategoryRow(),

              const SizedBox(height: 32), // mt-8

              // ── Nearby Stores ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SectionHeader(
                  title: AppStrings.nearbyStores,
                  onSeeAll: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 2;
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildNearbyStores(ref, context),

              const SizedBox(height: 32), // mt-8

              // ── Weekly Rewards preview ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SectionHeader(
                  title: AppStrings.weeklyRewards,
                  onSeeAll: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 1;
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildRewardsPreview(ref, context),

              const SizedBox(height: 32), // mt-8

            ],
          ),
        ),
      ),
    );
  }



  // ─────────────────────────────────────────────────────────────
  //  Nearby Stores — horizontal scroll, fixed-height cards
  // ─────────────────────────────────────────────────────────────
  Widget _buildNearbyStores(WidgetRef ref, BuildContext context) {
    final storesAsync = ref.watch(filteredStoresProvider);

    return storesAsync.when(
      data: (stores) {
        if (stores.isEmpty) {
          return const SizedBox(
            height: 120,
            child: Center(child: Text(AppStrings.noResults)),
          );
        }

        final mid = (stores.length / 2).ceil();
        final row1 = stores.sublist(0, mid);
        final row2 = stores.sublist(mid);

        return Column(
          children: [
            // Row 1
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20, right: 8),
                itemExtent: 152, // 140 width + 12 padding
                itemCount: row1.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: StoreCard(store: row1[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Row 2
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20, right: 8),
                itemExtent: 152, // 140 width + 12 padding
                itemCount: row2.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: StoreCard(store: row2[index]),
                  );
                },
              ),
            ),

          ],
        );
      },
      loading: () => const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) =>
          SizedBox(height: 120, child: Center(child: Text('Error: $err'))),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  Rewards preview — small horizontal cards on home
  // ─────────────────────────────────────────────────────────────
  Widget _buildRewardsPreview(WidgetRef ref, BuildContext context) {
    final rewardsAsync = ref.watch(rewardsProvider);

    return rewardsAsync.when(
      data: (rewards) {
        return SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20, right: 8),
            itemExtent: 254, // 240 width + 14 padding

            itemCount: rewards.length,
            itemBuilder: (context, index) {
              final reward = rewards[index];
              return Container(
                width: 240,

                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: _getColorFromHex(
                        reward.gradientColors[0],
                      ).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background image
                      Image.network(
                        reward.imageUrl,
                        fit: BoxFit.cover,
                        cacheWidth: 600,
                        errorBuilder: (ctx, err, st) => Container(
                          color: _getColorFromHex(reward.gradientColors[0]),
                        ),
                      ),

                      // Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 140, // Height of the gradient overlay
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                _getColorFromHex(
                                  reward.gradientColors[0],
                                ).withValues(alpha: 0.8),
                                _getColorFromHex(reward.gradientColors[0]),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Top Pill (Primary / Eligible)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                index % 2 == 0
                                    ? Icons.stars
                                    : Icons.check_circle,
                                color: AppColors.kutootRed,
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                index % 2 == 0 ? 'PRIMARY' : 'ELIGIBLE',
                                style: const TextStyle(
                                  color: AppColors.kutootRed,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Content
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reward.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'TOTAL VALUE ₹${(reward.targetCount * 100).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Mock dashed progress bar + percentage text
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 3,
                                    child: RepaintBoundary(
                                      child: CustomPaint(
                                        painter: ProgressBarPainter(progress: reward.progress),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${(reward.progress * 100).toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 360,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) =>
          SizedBox(height: 120, child: Center(child: Text('Error: $err'))),
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse("0x$hexColor"));
  }
}

class ProgressBarPainter extends CustomPainter {
  final double progress;
  final int totalSegments;

  ProgressBarPainter({required this.progress, this.totalSegments = 8});

  @override
  void paint(Canvas canvas, Size size) {
    final filledPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final emptyPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.fill;

    final double gap = 2.0;
    final double totalGapWidth = gap * (totalSegments - 1);
    final double segmentWidth = (size.width - totalGapWidth) / totalSegments;
    final int filledSegments = (progress * totalSegments).round();

    double startX = 0;
    for (int i = 0; i < totalSegments; i++) {
      final paint = i < filledSegments ? filledPaint : emptyPaint;
      canvas.drawRect(
        Rect.fromLTWH(startX, 0, segmentWidth, size.height), 
        paint,
      );
      startX += segmentWidth + gap;
    }
  }

  @override
  bool shouldRepaint(covariant ProgressBarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
