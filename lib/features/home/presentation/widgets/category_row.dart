import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/providers/app_providers.dart';
import 'package:kuttot/features/shell/presentation/shell_screen.dart';

class CategoryRow extends ConsumerWidget {
  const CategoryRow({super.key});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'checkroom':
        return Icons.checkroom;
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'devices':
        return Icons.devices;
      case 'spa':
        return Icons.spa;
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.category;
    }
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse("0x$hexColor"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        return SizedBox(
          height: 110,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),

            itemCount: categories.length + 1, // +1 for "ALL"
            itemBuilder: (context, index) {
              if (index == 0) {
                // "ALL" Category
                return Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: GestureDetector(
                    onTap: () {
                      ref.read(selectedCategoryProvider.notifier).state = 'All';
                      ref.read(bottomNavIndexProvider.notifier).state = 2;
                    },
                    child: Column(
                      children: [
                        Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),

                        child: const Center(
                          child: Icon(
                            Icons.grid_view_rounded,
                            color: AppColors.primary,
                            size: 28,

                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ALL',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),

                      ),
                    ],
                  ),
                ),
              );
            }

              final category = categories[index - 1];
              final isFashion = category.name.toLowerCase() == 'fashion';
              // Match Fashion strictly to the dark red to match mockup if needed
              final colorHex = isFashion ? "#BE1E48" : category.color;
              final bgColor = _getColorFromHex(colorHex);

              return RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                child: GestureDetector(
                  onTap: () {
                    ref.read(selectedCategoryProvider.notifier).state = category.name;
                    ref.read(bottomNavIndexProvider.notifier).state = 2;
                  },
                  child: Column(
                    children: [
                      Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: bgColor,
                      ),
                      child: Center(
                        child: Icon(
                          _getIconData(category.icon),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: 0,

                      ),
                    ),
                  ],
                ),
              ),
            ));
          },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => SizedBox(
        height: 100,
        child: Center(child: Text('Error: $err')),
      ),
    );
  }
}
