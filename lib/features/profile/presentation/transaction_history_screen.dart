import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/providers/transaction_provider.dart';
import 'package:kuttot/core/providers/profile_provider.dart';
import 'package:kuttot/core/providers/location_provider.dart';
import 'package:kuttot/features/home/presentation/widgets/location_search_sheet.dart';
import 'package:kuttot/data/models/transaction_model.dart';
import 'package:kuttot/features/profile/presentation/transaction_details_screen.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends ConsumerState<TransactionHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<TransactionModel> _getDisplayTransactions(List<TransactionModel> realTransactions) {
    if (realTransactions.isNotEmpty) return realTransactions;

    // Demo Data
    return [
      TransactionModel(
        id: '1',
        storeName: 'Westside Store',
        amountPaid: 1981.00,
        discountApplied: 150.00,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        status: 'Success',
      ),
      TransactionModel(
        id: '2',
        storeName: 'Basic Plan Upgrade',
        amountPaid: 1.00,
        discountApplied: 0,
        timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 5)),
        status: 'Success',
      ),
      TransactionModel(
        id: '3',
        storeName: 'Starbucks',
        amountPaid: 450.00,
        discountApplied: 45.00,
        timestamp: DateTime.now().subtract(const Duration(days: 10, hours: 1)),
        status: 'Success',
      ),
      TransactionModel(
        id: '4',
        storeName: 'Reliance Digital',
        amountPaid: 12500.00,
        discountApplied: 1250.00,
        timestamp: DateTime.now().subtract(const Duration(days: 20, hours: 4)),
        status: 'Success',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final realTransactions = ref.watch(transactionProvider);
    final transactions = _getDisplayTransactions(realTransactions);
    final profile = ref.watch(profileProvider);
    
    final locationAsync = ref.watch(locationProvider);
    final locationName = locationAsync.valueOrNull ?? 'Mumbai';
    final locationTitle = locationName.isEmpty ? 'Mumbai' : locationName[0].toUpperCase() + locationName.substring(1).toLowerCase();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _buildPremiumAppBar(context, profile, locationTitle),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Editorial Header
                  _buildEditorialHeader(locationTitle),
                  
                  const SizedBox(height: 32),
                  
                  // Transaction List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildTransactionCard(transactions[index]);
                    },
                  ),
                  
                  // End of List Hint
                  _buildEndOfListHint(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumAppBar(BuildContext context, UserProfile profile, String locationTitle) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: AppColors.kutootMaroon),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                Image.asset('assets/images/screen.png', height: 28),
                const SizedBox(width: 16),
                // Location Picker
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const LocationSearchSheet(),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppColors.kutootMaroon),
                        const SizedBox(width: 4),
                        Text(
                          locationTitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 14, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Profile Image
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.kutootMaroon.withValues(alpha: 0.1), width: 2),
                image: DecorationImage(
                  image: _getProfileImageProvider(profile.profileImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorialHeader(String locationTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HISTORY',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA04100),
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Recent\nTransactions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: AppColors.kutootMaroon,
            height: 1.1,
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Manage your spending and rewards across $locationTitle stores.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(TransactionModel tx) {
    // Determine icon and color based on store name
    IconData icon;
    Color themeColor;
    
    if (tx.storeName.contains('Plan')) {
      icon = Icons.auto_awesome;
      themeColor = const Color(0xFFA04100);
    } else if (tx.storeName.contains('Starbucks')) {
      icon = Icons.coffee;
      themeColor = const Color(0xFF725C00); // Tertiary
    } else if (tx.storeName.contains('Reliance')) {
      icon = Icons.devices;
      themeColor = AppColors.kutootMaroon;
    } else {
      icon = Icons.shopping_bag;
      themeColor = AppColors.kutootMaroon;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailsScreen(transaction: tx),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.surfaceContainerHigh),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      child: Stack(
        children: [
          // Left indicator strip
          Positioned(
            left: -20,
            top: -20,
            bottom: -20,
            child: Container(
              width: 5,
              color: themeColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: themeColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.storeName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(tx.timestamp),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${tx.amountPaid.toStringAsFormat()}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.green.shade100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'SUCCESS',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.green.shade800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  ImageProvider _getProfileImageProvider(String? path) {
    const defaultUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuCXOmKuKDZ0kawYnXgO4dyE2mptVjBzgrXymCRsMvbE6hl0JanUH2Ae4-P0eZGp9SOJHtLP-NcsX_MCRti5vkC9G5aiEz4xS_oMqXo_axSl9q8x6H6eJgGENGgVxluz0Gnj7LzCH5df9ZenKu4RwvWWlOvJbkN_zVZK0TghpCSHonixzUJLOs7nSzL_7WYb0rDOuDWIZVcvKP7oDFLJY03yB6fx5SCIJQgfDYm1MglZCYoSV5xGzxpn7MsQwyce6UNqpxvNQwspICE';
    
    if (path == null || path.isEmpty) {
      return const NetworkImage(defaultUrl);
    }

    if (path.startsWith('http')) {
      return NetworkImage(path);
    }

    return FileImage(File(path));
  }

  Widget _buildEndOfListHint() {
    return Column(
      children: [
        const SizedBox(height: 48),
        Center(
          child: Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'No more transactions in the last 30 days.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

extension DoubleFormatting on double {
  String toStringAsFormat() {
    final formatter = NumberFormat('#,##,##0.00', 'en_IN');
    return formatter.format(this);
  }
}
