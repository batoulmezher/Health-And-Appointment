// lib/models/prescription.dart
class Prescription {
  final int id;
  final int appointmentId;
  final String? fileUrl;
  final String instructions;
  final DateTime createdAt;
  final AppointmentInfo appointment;

  Prescription({
    required this.id,
    required this.appointmentId,
    this.fileUrl,
    required this.instructions,
    required this.createdAt,
    required this.appointment,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] ?? 0,
      appointmentId: json['appointment_id'] ?? 0,
      fileUrl: json['file_url'],
      instructions: json['instructions'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      appointment: AppointmentInfo.fromJson(json['appointment'] ?? {}),
    );
  }
}

class AppointmentInfo {
  final int id;
  final int patientId;
  final int doctorId;
  final String patientName;
  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;

  AppointmentInfo({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  factory AppointmentInfo.fromJson(Map<String, dynamic> json) {
    return AppointmentInfo(
      id: json['id'] ?? 0,
      patientId: json['patient_id'] ?? 0,
      doctorId: json['doctor_id'] ?? 0,
      patientName: json['patient_name'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      appointmentDate: json['appointment_date'] ?? '',
      appointmentTime: json['appointment_time'] ?? '',
    );
  }
}