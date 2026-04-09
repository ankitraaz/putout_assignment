import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/constants/app_strings.dart';
import 'package:kuttot/core/providers/app_providers.dart';
import 'package:kuttot/core/widgets/custom_search_bar.dart';
import 'package:kuttot/features/home/presentation/widgets/banner_card.dart';
import 'package:kuttot/features/home/presentation/widgets/category_row.dart';
import 'package:kuttot/features/home/presentation/widgets/section_header.dart';
import 'package:kuttot/features/home/presentation/widgets/store_card.dart';
import 'package:kuttot/features/shell/presentation/shell_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _buildHeader(context, ref),
              ),

              const SizedBox(height: 16),

              // ── Search ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomSearchBar(
                  hintText: AppStrings.searchHint,
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── Banner ──
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: BannerCard(),
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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

              const SizedBox(height: 24),

              // ── Nearby Stores ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SectionHeader(
                  title: AppStrings.nearbyStores,
                  onSeeAll: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 2;
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildNearbyStores(ref, context),

              const SizedBox(height: 24),

              // ── Weekly Rewards preview ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SectionHeader(
                  title: AppStrings.weeklyRewards,
                  onSeeAll: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 1;
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildRewardsPreview(ref, context),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  Header row: location + upgrade button
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Location Pill
        Container(
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
              const Text(
                'MUMBAI',
                style: TextStyle(
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

        // Logo Text (Centered)
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            children: [
              TextSpan(
                text: 'KUT',
                style: TextStyle(color: AppColors.kutootMaroon),
              ),
              TextSpan(
                text: 'OO',
                style: TextStyle(color: AppColors.locationOrange),
              ),
              TextSpan(
                text: 'T',
                style: TextStyle(color: AppColors.kutootMaroon),
              ),
            ],
          ),
        ),

        // Upgrade Button
        Container(
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
              ref.read(bottomNavIndexProvider.notifier).state = 3; // Index 3 is Plans
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
      ],
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
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 16, right: 8),
                itemCount: row1.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: StoreCard(store: row1[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            // Row 2
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 16, right: 8),
                itemCount: row2.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
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
          height: 360,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 8),
            itemCount: rewards.length,
            itemBuilder: (context, index) {
              final reward = rewards[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: _getColorFromHex(reward.gradientColors[0]).withValues(alpha: 0.3),
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
                                _getColorFromHex(reward.gradientColors[0]).withValues(alpha: 0.8),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                index % 2 == 0 ? Icons.stars : Icons.check_circle, 
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
                                  child: Row(
                                    children: List.generate(8, (i) {
                                      final isFilled = i < (reward.progress * 8).round();
                                      return Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 2),
                                          height: 3,
                                          color: isFilled ? Colors.white : Colors.white24,
                                        ),
                                      );
                                    }).toList(),
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
