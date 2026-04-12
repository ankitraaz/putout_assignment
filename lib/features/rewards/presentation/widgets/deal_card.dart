import 'package:flutter/material.dart';
import 'package:kuttot/core/constants/app_colors.dart';

class DealCard extends StatelessWidget {
  final String iconUrl;
  final String categoryText;
  final Color categoryColor;
  final String title;
  final String highlightText;
  final IconData highlightIcon;
  final String validityText;
  final bool isApplied;
  final String buttonText;
  final VoidCallback? onTap;

  const DealCard({
    super.key,
    required this.iconUrl,
    required this.categoryText,
    required this.categoryColor,
    required this.title,
    required this.highlightText,
    required this.highlightIcon,
    required this.validityText,
    this.isApplied = false,
    this.buttonText = "APPLY",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // 4% black
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // LEFT CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        // Logo Box
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              iconUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (ctx, _, __) => const Icon(Icons.store, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Title Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryText.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                  color: categoryColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3B322B),
                                  height: 1.1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Highlight Text
                    Text(
                      highlightText,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.kutootRed,
                        height: 1.0,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Validity Row
                    Row(
                      children: [
                        Icon(highlightIcon, size: 12, color: AppColors.textSecondary.withValues(alpha: 0.7)),
                        const SizedBox(width: 4),
                        Text(
                          validityText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // DOTTED DIVIDER
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CustomPaint(
                size: const Size(1.5, double.infinity),
                painter: _DottedDividerPainter(),
              ),
            ),

            // RIGHT ACTION
            SizedBox(
              width: 100,
              child: isApplied
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                        child: Container(
                          color: Colors.green.withValues(alpha: 0.05),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_circle, color: Colors.green, size: 24),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'APPLIED',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    : Center(
                        child: Material(
                          color: AppColors.kutootRed,
                          borderRadius: BorderRadius.circular(50),
                          elevation: 4,
                          shadowColor: AppColors.kutootRed.withValues(alpha: 0.2),
                          child: InkWell(
                            onTap: onTap,
                            borderRadius: BorderRadius.circular(50),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text(
                                buttonText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DottedDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE1BEC0)
      ..strokeWidth = 1.5;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
