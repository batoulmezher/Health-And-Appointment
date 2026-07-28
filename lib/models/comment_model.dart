// lib/models/comment_model.dart
class CommentModel {
  final int id;
  final String content;
  final DateTime createdAt;
  final Patient? patient;

 CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.patient,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      patient: json['patient'] != null ? Patient.fromJson(json['patient']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'patient': patient?.toJson(),
    };
  }
}

class Patient {
  final int id;
  final String fullName;
  final String? gender;
  final String? profilePictureUrl;

  Patient({
    required this.id,
    required this.fullName,
    this.gender,
    this.profilePictureUrl,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      gender: json['gender'],
      profilePictureUrl: json['profile_picture_url'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'gender': gender,
      'profile_picture_url': profilePictureUrl,
    };
  }
}