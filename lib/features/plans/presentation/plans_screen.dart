import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/core/constants/app_colors.dart';

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5), // surface
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 80)), // Header spacer
              
              // Hero Section
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: _HeroSection(),
                ),
              ),

              // Primary Actions
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                sliver: SliverToBoxAdapter(
                  child: _PrimaryActions(),
                ),
              ),

              // Curated Deals Section
              SliverPadding(
                padding: const EdgeInsets.only(top: 48, bottom: 120),
                sliver: SliverToBoxAdapter(
                  child: _DealsMatrix(),
                ),
              ),
            ],
          ),

          // Custom Header (Fixed)
          const _BrandHeader(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90), // Offset for floating bottom nav
        child: FloatingActionButton(
          onPressed: () {},
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

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  // Location Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEA6B1E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEA6B1E).withValues(alpha: 0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Color(0xFFEA6B1E)),
                        SizedBox(width: 4),
                        Text(
                          'MUMBAI ▾',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFEA6B1E),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Logo
                  Image.asset(
                    'assets/images/kutoot_logo.png',
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  // Upgrade Button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAE1E3F),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFAE1E3F).withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Text(
                      'UPGRADE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
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

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB29M1JbLS0G8L5cGhU0cIW8O-IrmW8-j_GWHl6jZBCAiVok4uzDgaVG64yH5wC-qaBz0N5IFXaj9UcPqkiMefkvlGrisxE4Qc08m18ccl9g40ZDEomDTVa1s6gfRoH_Ef8HMxUWR0dmFFd7zcQJ8l20BtTINi6pDOynvPFzti9rhX97J6s2kphanNmSIOkhHSaANBbLvDR6SCArnFfo3PuMkZPxGlzgt183k0S0_ps-vpFJpccLg-8NXXWMzlZReV-1pVh116O_yTu',
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
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: Row(
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
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF221A14),
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
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Westside',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF221A14),
                              letterSpacing: -1.0,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE080),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Color(0xFF231B00)),
                                SizedBox(width: 4),
                                Text(
                                  '4.8',
                                  style: TextStyle(
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
                      const Text(
                        'Premium Lifestyle & Global Fashion • MG Road, Bangalore',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF594042),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(Icons.near_me, size: 14, color: Color(0xFFAE1E3F)),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '1.2 KM AWAY',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.schedule, size: 14, color: Color(0xFFAE1E3F)),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '11:00 AM – 10:00 PM',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
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

  const _ActionButton({
    required this.label,
    required this.icon,
    this.color,
    this.gradient,
    required this.textColor,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _DealsMatrix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            itemCount: 2, // 2 groups of 2 columns
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _DealsGroup(
                  cards: [
                    _CouponCard(
                      title: '60% OFF',
                      subtitle: 'Premium apparel collections',
                      badge: 'Merchant Special',
                      badgeColor: const Color(0xFFAE1E3F),
                      tag: 'Elite',
                      code: 'WST60',
                    ),
                    _CouponCard(
                      title: '₹500 CB',
                      subtitle: 'Spends above ₹3,000 only',
                      badge: 'Flash Deal',
                      badgeColor: const Color(0xFFEA6B1E),
                      tag: 'Hot',
                      code: 'CASHBACK500',
                      isSecondaryAction: true,
                    ),
                  ],
                );
              } else {
                return _DealsGroup(
                  cards: [
                    _CouponCard(
                      title: '15% OFF',
                      subtitle: 'HDFC Card users exclusive',
                      badge: 'Bank Offer',
                      badgeColor: const Color(0xFF725C00),
                      code: 'Auto Applied',
                      isSecondaryAction: true,
                    ),
                    _CouponCard(
                      title: 'BOGO',
                      subtitle: 'On latest select footwear',
                      badge: 'New User',
                      badgeColor: const Color(0xFFAE1E3F),
                      tag: 'Select',
                      code: 'WESTBOGO',
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
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
          Expanded(child: cards[0]),
          const SizedBox(height: 16),
          Expanded(child: cards[1]),
        ],
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                        border: Border.all(color: badgeColor.withValues(alpha: 0.1)),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSecondaryAction ? const Color(0xFF221A14) : const Color(0xFFAE1E3F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'APPLY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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
            top: 130, // Adjusted to match the visual alignment of the divider
            child: _Cutout(),
          ),
          Positioned(
            right: -8,
            top: 130,
            child: _Cutout(),
          ),
          
          // Dashed Divider logic
          Positioned(
            left: 20,
            right: 20,
            top: 138,
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

class _DashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            color: Colors.black12,
          ),
        ),
      ),
    );
  }
}
