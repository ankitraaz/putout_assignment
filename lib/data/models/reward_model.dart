class RewardModel {
  final String id;
  final String title;
  final String description;
  final int points;
  final double progress;
  final int currentCount;
  final int targetCount;
  final List<String> gradientColors;
  final String imageUrl;
  final String expiresIn;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.progress,
    required this.currentCount,
    required this.targetCount,
    required this.gradientColors,
    required this.imageUrl,
    required this.expiresIn,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      points: json['points'] as int,
      progress: (json['progress'] as num).toDouble(),
      currentCount: json['currentCount'] as int,
      targetCount: json['targetCount'] as int,
      gradientColors: List<String>.from(json['gradientColors']),
      imageUrl: json['imageUrl'] as String,
      expiresIn: json['expiresIn'] as String,
    );
  }
}
