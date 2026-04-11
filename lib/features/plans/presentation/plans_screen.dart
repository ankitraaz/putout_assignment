import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/data/models/store_model.dart';
import 'package:kuttot/core/providers/app_providers.dart';
import 'package:kuttot/core/widgets/app_header.dart';
import 'package:kuttot/features/stores/presentation/payment_screen.dart';

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StoreModel? currentStore = ref.watch(selectedStoreProvider);
    
    if (currentStore == null) {
      final fallbackStoresAsync = ref.watch(storesProvider);
      final fallbackList = fallbackStoresAsync.valueOrNull;
      if (fallbackList != null && fallbackList.isNotEmpty) {
        currentStore = fallbackList.first;
      }
    }

    if (currentStore == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5), // surface
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.paddingOf(context).top + 64 + 32),
              ), // Dynamic Header spacer
              
              // Hero Section
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: _HeroSection(store: currentStore),
                ),
              ),

              // Primary Actions
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                sliver: SliverToBoxAdapter(
                  child: _PrimaryActions(store: currentStore),
                ),
              ),

              // Curated Deals Section
              SliverPadding(
                padding: const EdgeInsets.only(top: 48, bottom: 120),
                sliver: SliverToBoxAdapter(
                  child: _DealsMatrix(store: currentStore),
                ),
              ),
            ],
          ),

          // Custom Header (Fixed)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90), // Offset for floating bottom nav
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            if (currentStore != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(store: currentStore!),
                ),
              );
            }
          },
          backgroundColor: const Color(0xFFAE1E3F),
          shape: const CircleBorder(
            side: BorderSide(color: Colors.white24, width: 2),
          ),
          elevation: 12,
          child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final StoreModel store;
  
  const _HeroSection({required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(
            store.imageUrl,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Social Proof Badge
          Positioned(
            top: 24,
            left: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFAE1E3F),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '323 CUSTOMERS TRANSACTED TODAY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF221A14),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Glass Store Details
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                    boxShadow: const [
                       BoxShadow(
                         color: Colors.black26,
                         blurRadius: 25,
                         offset: Offset(0, 10),
                       ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              store.name,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF221A14),
                                letterSpacing: -1.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE080),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, size: 16, color: Color(0xFF231B00)),
                                const SizedBox(width: 4),
                                Text(
                                  store.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF231B00),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${store.category} • ${store.address}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF594042).withValues(alpha: 0.8),
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(Icons.near_me, size: 18, color: Color(0xFFAE1E3F)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '1.2 KM\nAWAY',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      color: Color(0xFF221A14),
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(Icons.schedule, size: 18, color: Color(0xFFAE1E3F)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '11:00 AM –\n10:00 PM',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      color: Color(0xFF221A14),
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

class _PrimaryActions extends StatelessWidget {
  final StoreModel store;
  const _PrimaryActions({required this.store});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Directions',
            icon: Icons.directions,
            color: const Color(0xFFEFE0D5),
            textColor: const Color(0xFF221A14),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActionButton(
            label: 'Pay Bill',
            icon: Icons.payments,
            gradient: const LinearGradient(
              colors: [Color(0xFFAE1E3F), Color(0xFFAE1E3F)],
            ),
            textColor: Colors.white,
            hasShadow: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(store: store),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final Gradient? gradient;
  final Color textColor;
  final bool hasShadow;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    this.color,
    this.gradient,
    required this.textColor,
    this.hasShadow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
      height: 56,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: const Color(0xFFAE1E3F).withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }
}

class _DealsMatrix extends ConsumerWidget {
  final StoreModel store;
  
  const _DealsMatrix({required this.store});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealsAsync = ref.watch(dealsProvider);

    return dealsAsync.when(
      data: (deals) {
        final activeDeals = deals.where((d) => 
          d.category == 'Bank Offers' || d.title.toLowerCase().contains(store.name.toLowerCase())
        ).take(4).toList();

        if (activeDeals.isEmpty) return const SizedBox.shrink();

        final group1 = activeDeals.take(2).toList();
        final group2 = activeDeals.skip(2).take(2).toList();

        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXCLUSIVE OFFERS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFAE1E3F),
                      letterSpacing: 2.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Curated Deals',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF221A14),
                    ),
                  ),
                ],
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF221A14).withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 420,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: group2.isNotEmpty ? 2 : 1,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final groupDeals = index == 0 ? group1 : group2;
              return _DealsGroup(
                cards: groupDeals.asMap().entries.map((entry) {
                  final dealIndex = entry.key;
                  final deal = entry.value;
                  return _CouponCard(
                    title: deal.highlightText,
                    subtitle: deal.title,
                    badge: deal.category == 'Bank Offers' ? 'Bank Offer' : 'Merchant Special',
                    badgeColor: deal.category == 'Bank Offers' ? const Color(0xFF725C00) : const Color(0xFFAE1E3F),
                    tag: deal.category == 'Bank Offers' ? '' : 'Elite',
                    code: deal.id,
                    isSecondaryAction: dealIndex == 1, // Bottom card button is black
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const SizedBox.shrink(),
    );
  }
}

class _DealsGroup extends StatelessWidget {
  final List<Widget> cards;
  const _DealsGroup({required this.cards});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          if (cards.isNotEmpty) Expanded(child: cards[0]),
          if (cards.length > 1) const SizedBox(height: 16),
          if (cards.length > 1) Expanded(child: cards[1]),
          if (cards.length == 1) ...[
            const SizedBox(height: 16),
            const Spacer(),
          ]
        ],
      ),
    );
  }
}

class _CouponCard extends ConsumerWidget {
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final String? tag;
  final String code;
  final bool isSecondaryAction;

  const _CouponCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    this.tag,
    required this.code,
    this.isSecondaryAction = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appliedDeals = ref.watch(appliedDealsProvider);
    final isApplied = appliedDeals.contains(code);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badge.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF221A14),
                        letterSpacing: -1.0,
                        height: 0.9,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF594042),
                            ),
                          ),
                        ),
                        if (tag != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Footer / Code Section
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF1E8),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                  border: Border(top: BorderSide(color: Colors.black12, style: BorderStyle.none)), // No horizontal lines rule
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CODE: $code',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF594042),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          ref.read(appliedDealsProvider.notifier).update((state) {
                            if (state.contains(code)) {
                              return state.difference({code});
                            } else {
                              return {...state, code};
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isApplied
                                ? Colors.green.withValues(alpha: 0.1)
                                : (isSecondaryAction ? const Color(0xFF221A14) : const Color(0xFFAE1E3F)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isApplied) ...[
                                const Icon(Icons.check_circle, color: Colors.green, size: 12),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                isApplied ? 'APPLIED' : 'APPLY',
                                style: TextStyle(
                                  color: isApplied ? Colors.green : Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Custom Cutouts (The half circles)
          Positioned(
            left: -8,
            bottom: 44, // Align exactly centered on the 52px footer
            child: _Cutout(),
          ),
          Positioned(
            right: -8,
            bottom: 44,
            child: _Cutout(),
          ),
          
          // Dashed Divider logic
          Positioned(
            left: 20,
            right: 20,
            bottom: 51,
            child: _DashedLine(),
          ),
        ],
      ),
    );
  }
}

class _Cutout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8F5), // Same as surface
        shape: BoxShape.circle,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double startX = 0;
    final double dashWidth = 8;
    final double dashSpace = 4;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) => false;
}

class _DashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: 1,
        width: double.infinity,
        child: CustomPaint(
          painter: DashedLinePainter(),
        ),
      ),
    );
  }
}
