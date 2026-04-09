import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/constants/app_strings.dart';
import 'package:kuttot/core/providers/app_providers.dart';
import 'package:kuttot/core/widgets/custom_search_bar.dart';
import 'package:kuttot/features/stores/presentation/widgets/category_filter_row.dart';
import 'package:kuttot/features/stores/presentation/widgets/curated_store_card.dart';

class StoresScreen extends ConsumerWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildHeader(context),
            ),
            const SizedBox(height: 16),

            // ── Search ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomSearchBar(
                hintText: 'Search stores, brands, or items...',
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
            ),
            const SizedBox(height: 16),

            // ── Category Chips ──
            const CategoryFilterRow(),
            const SizedBox(height: 20),

            // ── Title Row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nearby curated stores',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final storesAsync = ref.watch(filteredStoresProvider);
                      final count = storesAsync.valueOrNull?.length ?? 0;
                      return Text(
                        '$count STORES FOUND',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.kutootRed,
                          letterSpacing: 0.5,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Stores Grid ──
            Expanded(
              child: _buildStoresGrid(ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoresGrid(WidgetRef ref) {
    final storesAsync = ref.watch(filteredStoresProvider);

    return storesAsync.when(
      data: (stores) {
        if (stores.isEmpty) {
          return const Center(child: Text(AppStrings.noResults));
        }
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(bottom: 100),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.65, // Tune based on design
          ),
          itemCount: stores.length,
          itemBuilder: (context, index) {
            return CuratedStoreCard(store: stores[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  // Duplicate header to match exactly without affecting HomeScreen structure
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Location Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0E6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, color: AppColors.locationOrange, size: 14),
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
              const Icon(Icons.keyboard_arrow_down, color: AppColors.locationOrange, size: 16),
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
              TextSpan(text: 'KUT', style: TextStyle(color: AppColors.kutootMaroon)),
              TextSpan(text: 'OO', style: TextStyle(color: AppColors.locationOrange)),
              TextSpan(text: 'T', style: TextStyle(color: AppColors.kutootMaroon)),
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              minimumSize: const Size(0, 32),
            ),
            child: const Text('UPGRADE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          ),
        ),
      ],
    );
  }
}
