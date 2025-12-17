class VerificationResult {
  final int id;
  final int residentId;
  final String imagePath;
  final String prediction; // "utuh" atau "tidak_utuh"
  final double confidence; // 0-1
  final bool isValidForMarketplace; // true jika "utuh"
  final DateTime createdAt;
  final Map<String, double>? classProbabilities;

  const VerificationResult({
    required this.id,
    required this.residentId,
    required this.imagePath,
    required this.prediction,
    required this.confidence,
    required this.isValidForMarketplace,
    required this.createdAt,
    this.classProbabilities,
  });

  factory VerificationResult.fromJson(Map<String, dynamic> json) {
    return VerificationResult(
      id: json['id'] as int,
      residentId: json['resident_id'] as int,
      imagePath: json['image_path'] as String,
      prediction: json['prediction'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      isValidForMarketplace: json['is_valid_for_marketplace'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      classProbabilities: json['class_probabilities'] != null
          ? Map<String, double>.from(
              (json['class_probabilities'] as Map).map(
                (k, v) => MapEntry(k as String, (v as num).toDouble()),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resident_id': residentId,
      'image_path': imagePath,
      'prediction': prediction,
      'confidence': confidence,
      'is_valid_for_marketplace': isValidForMarketplace,
      'created_at': createdAt.toIso8601String(),
      'class_probabilities': classProbabilities,
    };
  }
}
