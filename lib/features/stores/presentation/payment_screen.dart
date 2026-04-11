import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kuttot/core/constants/app_colors.dart';
import 'package:kuttot/core/providers/app_providers.dart';
import 'package:kuttot/core/providers/transaction_provider.dart';
import 'package:kuttot/data/models/store_model.dart';
import 'package:kuttot/data/models/deal_model.dart';
import 'package:kuttot/data/models/transaction_model.dart';
import 'package:kuttot/features/rewards/presentation/widgets/deal_card.dart';
import 'package:kuttot/features/stores/presentation/payment_failed_screen.dart';
import 'package:kuttot/features/rewards/presentation/widgets/deal_card.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final StoreModel store;

  const PaymentScreen({super.key, required this.store});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isPaying = false;
  bool _isSuccess = false;
  String? _selectedRewardId = "1"; // Default to first reward
  String? _currentTxId;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _subtotal {
    final text = _amountController.text;
    if (text.isEmpty) return 0.0;
    return double.tryParse(text) ?? 0.0;
  }

  double _calculateDiscount(List<DealModel> activeDeals) {
    if (_subtotal == 0) return 0.0;
    double totalDiscount = 0.0;
    
    for (var deal in activeDeals) {
      bool isMatch = deal.category == 'Bank Offers' || 
                    deal.title.toLowerCase().contains(widget.store.name.toLowerCase());
                    
      if (isMatch) {
        String text = deal.highlightText.toUpperCase();
        if (text.contains('%')) {
          final match = RegExp(r'\d+').firstMatch(text);
          if (match != null) {
            double percent = double.parse(match.group(0)!);
            totalDiscount += (_subtotal * (percent / 100));
          }
        } else if (text.contains('₹')) {
          final match = RegExp(r'\d+').firstMatch(text.replaceAll(',', ''));
          if (match != null) {
            totalDiscount += double.parse(match.group(0)!);
          }
        }
      }
    }
    
    if (totalDiscount > _subtotal) totalDiscount = _subtotal;
    return totalDiscount;
  }

  double get _taxes => (_subtotal - _discount) * 0.05;
  double get _discount {
    final dealsAsync = ref.watch(dealsProvider);
    final appliedIds = ref.watch(appliedDealsProvider);
    if (dealsAsync.value == null) return 0.0;
    
    final active = dealsAsync.value!.where((d) => appliedIds.contains(d.id)).toList();
    return _calculateDiscount(active);
  }
  
  double get _finalAmount => (_subtotal - _discount) + _taxes;

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) return _buildSuccessScreen();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.kutootRed),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kutoot Store',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: AppColors.kutootRed),
                const SizedBox(width: 4),
                Text(
                  '${widget.store.address}',
                  style: const TextStyle(
                    color: AppColors.kutootRed,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.kutootRed.withValues(alpha: 0.1),
              child: const Icon(Icons.person, size: 20, color: AppColors.kutootRed),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Store Info Sub-Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1E8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.kutootRed.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.storefront, color: AppColors.kutootRed, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.store.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        widget.store.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Bill Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ENTER BILL AMOUNT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '₹',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.00',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Vibrant Deals Section
            _buildVibrantDealsList(),
            
            const SizedBox(height: 32),
            
            // Apply to Reward Section
            _buildRewardsList(),
            
            const SizedBox(height: 32),
            
            // Bill Details
            const Text(
              'BILL DETAILS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildBillRow('Subtotal', _subtotal, false),
            const SizedBox(height: 12),
            _buildBillRow('Discount Applied', _discount, true),
            const SizedBox(height: 12),
            _buildBillRow('Taxes & Fees', _taxes, false),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: Color(0xFFE1BEC0), thickness: 0.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Final Amount',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '₹${_finalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100), // padding for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              colors: [AppColors.kutootRed, Color(0xFFAE1E3F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.kutootRed.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: _subtotal > 0 ? () async {
                setState(() => _isPaying = true);
                
                try {
                  final result = await InternetAddress.lookup('google.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    await Future.delayed(const Duration(milliseconds: 1500));
                    
                    final txId = 'KT-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
                    final newTx = TransactionModel(
                      id: txId,
                      storeName: widget.store.name,
                      amountPaid: _finalAmount,
                      discountApplied: _discount, // Changed from _totalDiscount since it uses the getter
                      timestamp: DateTime.now(),
                      status: 'SUCCESS',
                    );
                    
                    await ref.read(transactionProvider.notifier).addTransaction(newTx);
                    
                    if (mounted) {
                      setState(() {
                        _currentTxId = txId;
                        _isPaying = false;
                        _isSuccess = true;
                      });
                    }
                  }
                } on SocketException catch (_) {
                  setState(() => _isPaying = false);
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentFailedScreen(amount: _finalAmount),
                      ),
                    );
                  }
                }
              } : null,
              child: Center(
                child: _isPaying 
                    ? const SizedBox(
                        height: 24, 
                        width: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'PAY NOW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5), // bg-background
      body: Stack(
        children: [
          // Main Content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 96, left: 24, right: 24, bottom: 96), // pt-24 px-6 pb-24
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Success Animation/Hero Section
                  Container(
                    width: 96, // w-24
                    height: 96, // h-24
                    margin: const EdgeInsets.only(bottom: 24), // mb-6
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFAE1E3F), Color(0xFF8A002B)], // crimson-gradient
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8A002B).withValues(alpha: 0.25),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.check_circle, color: Colors.white, size: 48),
                    ),
                  ),
                  const Text(
                    'PAYMENT SUCCESSFUL',
                    style: TextStyle(
                      fontSize: 12, // text-xs
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA04100), // text-secondary
                      letterSpacing: 1.5, // tracking-widest
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${_finalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 48, // text-5xl
                      fontWeight: FontWeight.w900, // font-extrabold
                      color: Color(0xFF221A14), // text-on-surface
                      letterSpacing: -1.5, // tracking-tighter
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Paid to ${widget.store.name}',
                    style: const TextStyle(
                      fontSize: 18, // text-lg
                      fontWeight: FontWeight.w500, // font-medium
                      color: Color(0xFF594042), // text-on-surface-variant
                    ),
                  ),
                  
                  const SizedBox(height: 48), // mt-12 mb-12 approx gap
                  
                  // Bento Grid Layout (Vertical for Mobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Rewards/Gamification Card (Large)
                      Container(
                        padding: const EdgeInsets.all(24), // p-6
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1E8), // bg-surface-container-low
                          borderRadius: BorderRadius.circular(16), // rounded-lg
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: [

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '5 Stamps Earned',
                                            style: TextStyle(
                                              fontSize: 20, // text-xl
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF221A14), // text-on-surface
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Luxury Villa Campaign',
                                            style: TextStyle(
                                              fontSize: 14, // text-sm
                                              color: Color(0xFF594042), // text-on-surface-variant
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16), // space-y-4
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'PROGRESS',
                                      style: TextStyle(
                                        fontSize: 12, // text-xs
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF8A002B), // text-primary
                                        letterSpacing: 0.5, // tracking-wider
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      '15 / 20 STAMPS',
                                      style: TextStyle(
                                        fontSize: 24, // text-2xl
                                        fontWeight: FontWeight.w900, // font-extrabold
                                        color: Color(0xFF221A14), // text-on-surface
                                        letterSpacing: -0.5, // tracking-tight
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16), // gap-4
                      
                      // Transaction Details Card
                      Container(
                        padding: const EdgeInsets.all(24), // p-6
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFE0D5).withValues(alpha: 0.4), // bg-surface-container-highest/40
                          borderRadius: BorderRadius.circular(16), // rounded-lg
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.receipt_long, size: 24, color: Color(0xFF594042)), // text-on-surface-variant
                                const SizedBox(width: 12), // gap-3
                                const Text(
                                  'TRANSACTION INFO',
                                  style: TextStyle(
                                    fontSize: 12, // text-xs
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF594042), // text-on-surface-variant
                                    letterSpacing: 1.5, // tracking-widest
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12), // space-y-3
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TRANSACTION ID',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF594042), letterSpacing: 1.5),
                                ),
                                Text(
                                  _currentTxId ?? 'KT-UNKNOWN',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF221A14), fontFamily: 'monospace'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'DATE & TIME',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF594042), letterSpacing: 1.5),
                                ),
                                Text(
                                  DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.now()),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF221A14)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16), // gap-4
                      
                      // Payment Method Card
                      Container(
                        padding: const EdgeInsets.all(24), // p-6
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFE0D5).withValues(alpha: 0.4), // bg-surface-container-highest/40
                          borderRadius: BorderRadius.circular(16), // rounded-lg
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.account_balance_wallet, size: 24, color: Color(0xFF594042)),
                                const SizedBox(width: 12), // gap-3
                                const Text(
                                  'PAYMENT METHOD',
                                  style: TextStyle(
                                    fontSize: 12, // text-xs
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF594042),
                                    letterSpacing: 1.5, // tracking-widest
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16), // mt-4
                            Row(
                              children: [
                                Container(
                                  width: 48, // w-12
                                  height: 32, // h-8
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF221A14), // bg-on-surface
                                    borderRadius: BorderRadius.circular(4), // rounded
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'VISA',
                                      style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16), // gap-4
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('HDFC Bank •••• 4242', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF221A14))),
                                    const Text('UPI Ref: 32901123485', style: TextStyle(fontSize: 10, color: Color(0xFF594042))),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48), // mt-12
                  
                  // Action Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFAE1E3F), Color(0xFF8A002B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(9999), // rounded-full
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8A002B).withValues(alpha: 0.15),
                              blurRadius: 32,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 20), // py-5
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                          child: const Text(
                            'Back to Home',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16), // space-y-4 approx gap
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16, // gap-4 
                        runSpacing: 8,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.share, size: 20, color: Color(0xFF594042)),
                            label: const Text('SHARE RECEIPT', style: TextStyle(color: Color(0xFF594042), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download, size: 20, color: Color(0xFF594042)),
                            label: const Text('DOWNLOAD PDF', style: TextStyle(color: Color(0xFF594042), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Fixed Top App Bar 
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80, // h-16 + safe area approx
              padding: const EdgeInsets.only(top: 40, left: 24, right: 24), // px-6
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8), // bg-white/80
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Color(0xFF221A14), size: 24),
                      ),
                      const SizedBox(width: 16), // gap-4
                      const Text(
                        'Payment Status',
                        style: TextStyle(
                          color: Color(0xFF221A14),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/images/screen.png',
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, double amount, bool isDiscount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.w600,
            color: isDiscount ? AppColors.kutootRed : AppColors.textSecondary,
          ),
        ),
        Text(
          '${isDiscount ? '-' : ''}₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.w600,
            color: isDiscount ? AppColors.kutootRed : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildVibrantDealsList() {
    final dealsAsync = ref.watch(dealsProvider);
    final appliedIds = ref.watch(appliedDealsProvider);
    
    if (dealsAsync.value == null) return const SizedBox.shrink();
    
    final activeDeals = dealsAsync.value!.where((d) {
      return d.category == 'Bank Offers' || d.title.toLowerCase().contains(widget.store.name.toLowerCase());
    }).toList();
    
    if (activeDeals.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Vibrant Deals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'View All',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.kutootRed.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: activeDeals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final deal = activeDeals[index];
              final isApplied = appliedIds.contains(deal.id);
              
              return GestureDetector(
                onTap: () {
                  ref.read(appliedDealsProvider.notifier).update((state) {
                    final newState = Set<String>.from(state);
                    if (isApplied) {
                      newState.remove(deal.id);
                    } else {
                      newState.add(deal.id);
                    }
                    return newState;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 288, // w-72 equivalent
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24), // rounded-3xl
                    color: isApplied ? const Color(0xFF981E32) : Colors.white,
                    border: isApplied ? null : Border.all(color: const Color(0xFFE1BEC0), width: 1.5), // Custom secondary border
                    boxShadow: [
                      if (isApplied)
                        BoxShadow(
                          color: const Color(0xFF981E32).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      else
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Decorative Blur circle for APPLIED state
                      if (isApplied)
                        Positioned(
                          right: -32,
                          top: -32,
                          child: Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      // Main Content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isApplied ? 'PROMO CODE' : deal.validityText.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.0,
                                        color: isApplied ? Colors.white.withValues(alpha: 0.7) : AppColors.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      deal.id, // "WESTSIDE20" or "FESTIVE500"
                                      style: TextStyle(
                                        fontSize: 24, // text-2xl
                                        fontWeight: FontWeight.w900, // font-black
                                        letterSpacing: -0.5,
                                        color: isApplied ? Colors.white : AppColors.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (isApplied)
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.kutootRed.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'APPLY',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                      color: AppColors.kutootRed,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (isApplied)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${deal.highlightText} APPLIED'.toUpperCase(), // "20% FLAT OFF APPLIED"
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  color: Color(0xFF981E32),
                                ),
                              ),
                            )
                          else
                            Text(
                              '${deal.highlightText} on ${deal.title}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary.withValues(alpha: 0.9),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsList() {
    final rewardsAsync = ref.watch(rewardsProvider);
    
    if (rewardsAsync.value == null || rewardsAsync.value!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Only show rewards that look like 'tasks' (targets > 0)
    final taskRewards = rewardsAsync.value!.where((r) => r.targetCount > 0).toList();
    if (taskRewards.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Apply to Reward',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: taskRewards.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final reward = taskRewards[index];
              final isSelected = _selectedRewardId == reward.id;
              
              int target = reward.targetCount;
              int current = reward.currentCount;
              double progressRatio = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
              
              return GestureDetector(
                onTap: () => setState(() => _selectedRewardId = reward.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected 
                      ? Border.all(color: const Color(0xFFA04100), width: 2) // secondary color
                      : Border.all(color: const Color(0xFFE1BEC0).withValues(alpha: 0.4), width: 1),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ] : null,
                  ),
                  child: Stack(
                    children: [
                      // Image Header
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                        child: SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                reward.imageUrl,
                                fit: BoxFit.cover,
                                color: isSelected ? null : Colors.black.withValues(alpha: 0.5),
                                colorBlendMode: isSelected ? null : BlendMode.saturation,
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFA04100),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                  ),
                                ),
                              if (isSelected)
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'SELECTED',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Content
                      Positioned(
                        top: 120,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      reward.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                        color: AppColors.textPrimary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$current/$target',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: isSelected ? const Color(0xFFA04100) : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: List.generate(5, (i) {
                                      final isFilled = i < (progressRatio * 5).floor();
                                      return Expanded(
                                        child: Container(
                                          height: 8,
                                          margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
                                          decoration: BoxDecoration(
                                            color: isFilled 
                                              ? (isSelected ? const Color(0xFFA04100) : AppColors.kutootRed.withValues(alpha: 0.4))
                                              : const Color(0xFFEFE0D5),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${(progressRatio * 100).toInt()}% COMPLETE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
