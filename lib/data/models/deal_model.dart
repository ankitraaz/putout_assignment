class DealModel {
  final String id;
  final String category;
  final String iconUrl;
  final String title;
  final String highlightText;
  final String validityText;
  final String buttonText;
  final String highlightIconString;

  DealModel({
    required this.id,
    required this.category,
    required this.iconUrl,
    required this.title,
    required this.highlightText,
    required this.validityText,
    required this.buttonText,
    required this.highlightIconString,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(
      id: json['id'] as String,
      category: json['category'] as String,
      iconUrl: json['iconUrl'] as String,
      title: json['title'] as String,
      highlightText: json['highlightText'] as String,
      validityText: json['validityText'] as String,
      buttonText: json['buttonText'] as String,
      highlightIconString: json['highlightIconString'] as String,
    );
  }
}
