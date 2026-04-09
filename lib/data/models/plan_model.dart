class PlanModel {
  final String id;
  final String name;
  final int price;
  final String duration;
  final List<String> gradientColors;
  final List<String> features;
  final bool isPopular;

  PlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.gradientColors,
    required this.features,
    required this.isPopular,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      duration: json['duration'] ?? '',
      gradientColors: List<String>.from(json['gradientColors'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      isPopular: json['isPopular'] ?? false,
    );
  }
}
