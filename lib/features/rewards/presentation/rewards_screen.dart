import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/constants/app_dimens.dart';
import 'package:kuttot/core/constants/app_strings.dart';
import 'package:kuttot/core/providers/app_providers.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(AppStrings.weeklyRewards),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.paddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete tasks to earn points!',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppDimens.paddingLG),
                  _buildRewardsCarousel(ref, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsCarousel(WidgetRef ref, BuildContext context) {
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
              return RepaintBoundary(
                child: Container(
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
                        height: 140,
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
