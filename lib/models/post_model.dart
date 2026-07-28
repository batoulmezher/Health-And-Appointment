// lib/models/post_model.dart
import 'doctor_model.dart';

class PostModel {
  final int id;
  final Doctor? doctor;
  final String content;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByCurrentUser;
  final DateTime createdAt;
  final String? imageUrl;

  PostModel({
    required this.id,
    this.doctor,
    required this.content,
    required this.likesCount,
    required this.commentsCount,
    required this.isLikedByCurrentUser,
    required this.createdAt,
    this.imageUrl,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
      content: json['content'] ?? '',
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments'] ?? json['comments_count'] ?? 0,
      isLikedByCurrentUser: json['is_liked_by_current_user'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor': doctor?.toJson(),
      'content': content,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'is_liked_by_current_user': isLikedByCurrentUser,
      'created_at': createdAt.toIso8601String(),
      'image_url': imageUrl,
    };
  }
}

class Doctor {
  final int? id;
  final int? userId;
  final String? licenseNumber;
  final int? specialtyId;
  final String? bio;
  final String? ratingAverage;
  final String? status;
  final User? user;

  Doctor({
    this.id,
    this.userId,
    this.licenseNumber,
    this.specialtyId,
    this.bio,
    this.ratingAverage,
    this.status,
    this.user,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      userId: json['user_id'],
      licenseNumber: json['license_number'],
      specialtyId: json['specialty_id'],
      bio: json['bio'],
      ratingAverage: json['rating_average'],
      status: json['status'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'license_number': licenseNumber,
      'specialty_id': specialtyId,
      'bio': bio,
      'rating_average': ratingAverage,
      'status': status,
      'user': user?.toJson(),
    };
  }
}

class User {
  final int? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? profilePictureUrl;

  User({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      profilePictureUrl: json['profile_picture_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'profile_picture_url': profilePictureUrl,
    };
  }
}
