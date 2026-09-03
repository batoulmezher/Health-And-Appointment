// lib/models/appointment_model.dart
class AppointmentModel {
  final int id;
  final String appointmentDate;
  final String appointmentTime;
  final String status;
  final String doctorName;
  final String specialtyName;
  final String? clinicLocation;
  final String? doctorProfilePic;

  AppointmentModel({
    required this.id,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.doctorName,
    required this.specialtyName,
    this.clinicLocation,
    this.doctorProfilePic,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final doctor = json['doctor'] as Map<String, dynamic>?;
    final user = doctor?['user'] as Map<String, dynamic>?;
    final specialty = doctor?['specialty'] as Map<String, dynamic>?;

    return AppointmentModel(
      id: json['id'] ?? 0,
      appointmentDate: json['appointment_date'] ?? '',
      appointmentTime: json['appointment_time'] ?? '',
      status: json['status'] ?? 'UNKNOWN',
      doctorName: user?['full_name'] ?? 'طبيب',
      specialtyName: specialty?['name'] ?? 'تخصص غير معروف',
      clinicLocation: doctor?['clinic_location'],
      doctorProfilePic: user?['profile_picture_url'],
    );
  }
}