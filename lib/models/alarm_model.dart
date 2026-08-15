// lib/models/alarm_model.dart
import 'package:health_appointment_app/models/comment_model.dart';

import 'doctor_model.dart';

class AlarmModel {
  final int id;
  final String medicineName;
  final String dosage;
  final int quantity;
  final String frequency;
  final String alarmTime;     
  final bool isActive;     
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Patient? patient;

  AlarmModel({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.quantity,
    required this.frequency,
    required this.alarmTime,
    required this.isActive,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.patient,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'] ?? 0,
      medicineName: json['medicine_name'] ?? '',
      dosage: json['dosage'] ?? '',
      quantity: json['quantity'] ?? 0,
      frequency: json['frequency'] ?? '',
      alarmTime: json['alarm_time'] ?? '',
      isActive: json['is_active'] ?? false,
      status: json['status'] ?? 'غير معروف',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      patient: json['patient'] != null ? Patient.fromJson(json['patient']) : null,
    );
  }
}