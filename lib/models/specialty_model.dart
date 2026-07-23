import 'doctor_model.dart';

class SpecialtyModel {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int doctorsCount;
  final List<Data>? doctors;

  SpecialtyModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.doctorsCount,
    this.doctors,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    final doctorsList = json['doctors'] != null
        ? (json['doctors'] as List)
            .map((docJson) => Data.fromJson(docJson))
            .toList()
        : null;

    return SpecialtyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      doctorsCount: json['doctors_count'] ?? 0,
      doctors: doctorsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'doctors_count': doctorsCount,
      'doctors': doctors?.map((d) => d.toJson()).toList(),
    };
  }
}