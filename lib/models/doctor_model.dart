// lib/models/doctor_model.dart
class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final int price;
  final String imageUrl;
  final String availableTime;
  final String gender; 
  final String governorate; 
  Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.price,
    required this.imageUrl,
    required this.availableTime,
    required this.gender,
    required this.governorate,
  });
}