class TransactionModel {
  final String id;
  final String storeName;
  final double amountPaid;
  final double discountApplied;
  final DateTime timestamp;
  final String status;

  TransactionModel({
    required this.id,
    required this.storeName,
    required this.amountPaid,
    required this.discountApplied,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeName': storeName,
      'amountPaid': amountPaid,
      'discountApplied': discountApplied,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      storeName: json['storeName'] as String,
      amountPaid: (json['amountPaid'] as num).toDouble(),
      discountApplied: (json['discountApplied'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
    );
  }
}
