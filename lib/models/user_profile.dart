// lib/models/user_profile.dart
class UserProfile {
  final int id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String role;
  final String gender;
  final bool isActive;
  final String? suspendedUntil;
  final String? statusReason;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PatientData? patient;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    required this.gender,
    required this.isActive,
    this.suspendedUntil,
    this.statusReason,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
    this.patient,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      role: json['role'] ?? '',
      gender: json['gender'] ?? '',
      isActive: json['is_active'] ?? false,
      suspendedUntil: json['suspended_until'],
      statusReason: json['status_reason'],
      profilePictureUrl: json['profile_picture_url'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      patient: json['patient'] != null ? PatientData.fromJson(json['patient']) : null,
    );
  }
}

class PatientData {
  final int id;
  final int age;
  final double? weight;
  final double? height;
  final String? bloodType;
  final bool hasChronicDisease;
  final String? chronicDiseaseDescription;
  final String? currentMedications;

  PatientData({
    required this.id,
    required this.age,
    this.weight,
    this.height,
    this.bloodType,
    required this.hasChronicDisease,
    this.chronicDiseaseDescription,
    this.currentMedications,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      id: json['id'] ?? 0,
      age: json['age'] ?? 0,
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      bloodType: json['blood_type'],
      hasChronicDisease: json['has_chronic_disease'] ?? false,
      chronicDiseaseDescription: json['chronic_disease_description'],
      currentMedications: json['current_medications'],
    );
  }
}