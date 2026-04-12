import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/constants/app_strings.dart';
import 'package:kuttot/core/providers/app_providers.dart';
import 'package:kuttot/core/widgets/app_header.dart';
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
        bottom: false,
        child: Column(
          children: [
            // ── Header ──
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: AppHeader(),
            ),
            const SizedBox(height: 16),

            // ── Search ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8).copyWith(bottom: 100),
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
}
