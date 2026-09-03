// lib/models/review.dart
class Review {
  final int id;
  final int ratingScore;
  final String comment;
  final DateTime createdAt;
  final PatientReview? patient;

  Review({
    required this.id,
    required this.ratingScore,
    required this.comment,
    required this.createdAt,
    this.patient,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      ratingScore: json['rating_score'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      patient: json['patient'] != null ? PatientReview.fromJson(json['patient']) : null,
    );
  }
}

class PatientReview {
  final int id;
  final UserReview user;

  PatientReview({
    required this.id,
    required this.user,
  });

  factory PatientReview.fromJson(Map<String, dynamic> json) {
    return PatientReview(
      id: json['id'] ?? 0,
      user: UserReview.fromJson(json['user'] ?? {}),
    );
  }
}

class UserReview {
  final int id;
  final String fullName;

  UserReview({
    required this.id,
    required this.fullName,
  });

  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
    );
  }
}