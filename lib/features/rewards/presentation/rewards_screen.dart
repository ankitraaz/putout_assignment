import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/providers/app_providers.dart';
import 'package:kuttot/core/widgets/app_header.dart';
import 'package:kuttot/core/widgets/custom_search_bar.dart';
import 'package:kuttot/features/rewards/presentation/widgets/deal_card.dart';

class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen> {
  final List<String> categories = ['All', 'Merchant Deals', 'Bank Offers', 'Store Rewards'];
  int selectedCategoryIndex = 0;
  String searchQuery = '';

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'calendar_today': return Icons.calendar_today;
      case 'timer': return Icons.timer;
      case 'local_shipping': return Icons.local_shipping;
      case 'fastfood': return Icons.fastfood;
      case 'credit_card': return Icons.credit_card;
      case 'redeem': return Icons.redeem;
      case 'smartphone': return Icons.smartphone;
      case 'movie': return Icons.movie;
      case 'directions_car': return Icons.directions_car;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'stars': return Icons.stars;
      case 'card_giftcard': return Icons.card_giftcard;
      case 'flight': return Icons.flight;
      case 'receipt': return Icons.receipt;
      case 'clean_hands': return Icons.clean_hands;
      case 'movie_creation': return Icons.movie_creation;
      case 'airline_seat_flat': return Icons.airline_seat_flat;
      case 'qr_code_scanner': return Icons.qr_code_scanner;
      case 'account_balance_wallet': return Icons.account_balance_wallet;
      case 'local_pizza': return Icons.local_pizza;
      default: return Icons.local_offer;
    }
  }

  Color _getCategoryColor(String category) {
    if (category == 'Bank Offers') return AppColors.locationOrange;
    if (category == 'Store Rewards') return AppColors.textSecondary.withValues(alpha: 0.8);
    return AppColors.textSecondary.withValues(alpha: 0.6);
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse("0x$hexColor"));
  }

  Widget _buildWeeklyRewards(WidgetRef ref) {
    final rewardsAsync = ref.watch(rewardsProvider);

    return rewardsAsync.when(
      data: (rewards) {
        if (rewards.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 340,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: rewards.length,
            itemBuilder: (context, index) {
              final reward = rewards[index];
              return RepaintBoundary(
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _getColorFromHex(reward.gradientColors[0]).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          reward.imageUrl,
                          fit: BoxFit.cover,
                          cacheWidth: 600,
                          errorBuilder: (ctx, err, st) => Container(
                            color: _getColorFromHex(reward.gradientColors[0]),
                          ),
                        ),
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
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'TOTAL VALUE ₹${(reward.targetCount * 100).toString()}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
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
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 340, child: Center(child: CircularProgressIndicator())),
      error: (e, st) => SizedBox(height: 340, child: Center(child: Text("Error: $e"))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dealsAsync = ref.watch(dealsProvider);
    final appliedDeals = ref.watch(appliedDealsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F6),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: AppHeader(),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Exclusive Campaigns & Weekly Rewards ──
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'EXCLUSIVE CAMPAIGNS',
                                  style: TextStyle(
                                    color: AppColors.kutootRed,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Weekly Rewards',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildWeeklyRewards(ref),
                          
                          const SizedBox(height: 32),
                          const Divider(color: Colors.black12, height: 1, indent: 24, endIndent: 24),
                          const SizedBox(height: 24),
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const Text(
                              'Deals & Offers',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Search Bar ──
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CustomSearchBar(
                              hintText: 'Search brands, banks or items...',
                              onChanged: (val) {
                                setState(() {
                                  searchQuery = val.toLowerCase();
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ── Category Filters ──
                          SizedBox(
                            height: 40,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: categories.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final isSelected = index == selectedCategoryIndex;
                                return GestureDetector(
                                  onTap: () => setState(() => selectedCategoryIndex = index),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.locationOrange : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: isSelected ? null : Border.all(color: Colors.black.withValues(alpha: 0.05)),
                                      boxShadow: isSelected 
                                        ? [BoxShadow(color: AppColors.locationOrange.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 2))]
                                        : null,
                                    ),
                                    child: Text(
                                      categories[index],
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : AppColors.textPrimary.withValues(alpha: 0.7),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),

                  // ── Dynamic Deal Feed ──
                  dealsAsync.when(
                    data: (deals) {
                      final filteredDeals = deals.where((r) {
                        final catMatch = selectedCategoryIndex == 0 || r.category == categories[selectedCategoryIndex];
                        final searchMatch = r.title.toLowerCase().contains(searchQuery);
                        return catMatch && searchMatch;
                      }).toList();

                      if (filteredDeals.isEmpty) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              "No deals found for this filter.",
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final deal = filteredDeals[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: DealCard(
                                  iconUrl: deal.iconUrl,
                                  categoryText: deal.category,
                                  categoryColor: _getCategoryColor(deal.category),
                                  title: deal.title,
                                  highlightText: deal.highlightText,
                                  validityText: deal.validityText,
                                  buttonText: deal.buttonText,
                                  highlightIcon: _getIconData(deal.highlightIconString),
                                  isApplied: appliedDeals.contains(deal.id),
                                  onTap: () {
                                    ref.read(appliedDealsProvider.notifier).update((state) {
                                      if (state.contains(deal.id)) {
                                        return state.difference({deal.id});
                                      } else {
                                        return {...state, deal.id};
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                            childCount: filteredDeals.length,
                          ),
                        ),
                      );
                    },
                    loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                    error: (e, st) => SliverFillRemaining(child: Center(child: Text("Error: $e"))),
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
