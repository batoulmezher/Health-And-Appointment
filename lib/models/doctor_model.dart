// lib/models/doctor_model.dart

class DoctorModel {
  String? status;
  String? message;
  Data? data;

  DoctorModel({this.status, this.message, this.data});

  DoctorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['status'] = status;
    json['message'] = message;
    if (data != null) {
      json['data'] = data!.toJson();
    }
    return json;
  }
}

// ============================================================
// Data Class
// ============================================================
class Data {
  int? id;
  int? userId;
  String? licenseNumber;
  int? specialtyId;
  String? bio;
  String? ratingAverage;
  String? yearsOfExperience;
  String? clinicLocation;
  String? consultationFee;
  WorkingDaysHours? workingDaysHours;
  String? status;
  String? idImageUrl;
  String? certificateImageUrl;
  User? user;
  Specialty? specialty;
  List<Review>? reviews;

  Data({
    this.id,
    this.userId,
    this.licenseNumber,
    this.specialtyId,
    this.bio,
    this.ratingAverage,
    this.yearsOfExperience,
    this.clinicLocation,
    this.consultationFee,
    this.workingDaysHours,
    this.status,
    this.idImageUrl,
    this.certificateImageUrl,
    this.user,
    this.specialty,
    this.reviews,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    licenseNumber = json['license_number'];
    specialtyId = json['specialty_id'];
    bio = json['bio'];
    ratingAverage = json['rating_average'];
    yearsOfExperience = json['years_of_experience'];
    clinicLocation = json['clinic_location'];
    consultationFee = json['consultation_fee'];
    workingDaysHours = json['working_days_hours'] != null
        ? WorkingDaysHours.fromJson(json['working_days_hours'])
        : null;
    status = json['status'];
    idImageUrl = json['id_image_url'];
    certificateImageUrl = json['certificate_image_url'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    specialty = json['specialty'] != null
        ? Specialty.fromJson(json['specialty'])
        : null;
    if (json['reviews'] != null) {
      reviews = <Review>[];
      json['reviews'].forEach((v) {
        reviews!.add(Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['user_id'] = userId;
    json['license_number'] = licenseNumber;
    json['specialty_id'] = specialtyId;
    json['bio'] = bio;
    json['rating_average'] = ratingAverage;
    json['years_of_experience'] = yearsOfExperience;
    json['clinic_location'] = clinicLocation;
    json['consultation_fee'] = consultationFee;
    if (workingDaysHours != null) {
      json['working_days_hours'] = workingDaysHours!.toJson();
    }
    json['status'] = status;
    json['id_image_url'] = idImageUrl;
    json['certificate_image_url'] = certificateImageUrl;
    if (user != null) {
      json['user'] = user!.toJson();
    }
    if (specialty != null) {
      json['specialty'] = specialty!.toJson();
    }
    if (reviews != null) {
      json['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

// ============================================================
// Working Days Hours Class
// ============================================================
class WorkingDaysHours {
  DaySchedule? monday;
  DaySchedule? sunday;
  DaySchedule? tuesday;
  DaySchedule? thursday;
  DaySchedule? wednesday;
  DaySchedule? friday;
  DaySchedule? saturday;

  WorkingDaysHours({
    this.monday,
    this.sunday,
    this.tuesday,
    this.thursday,
    this.wednesday,
    this.friday,
    this.saturday,
  });

  WorkingDaysHours.fromJson(Map<String, dynamic> json) {
    monday = json['monday'] != null ? DaySchedule.fromJson(json['monday']) : null;
    sunday = json['sunday'] != null ? DaySchedule.fromJson(json['sunday']) : null;
    tuesday = json['tuesday'] != null ? DaySchedule.fromJson(json['tuesday']) : null;
    thursday = json['thursday'] != null ? DaySchedule.fromJson(json['thursday']) : null;
    wednesday = json['wednesday'] != null
        ? DaySchedule.fromJson(json['wednesday'])
        : null;
    friday = json['friday'] != null ? DaySchedule.fromJson(json['friday']) : null;
    saturday = json['saturday'] != null ? DaySchedule.fromJson(json['saturday']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (monday != null) json['monday'] = monday!.toJson();
    if (sunday != null) json['sunday'] = sunday!.toJson();
    if (tuesday != null) json['tuesday'] = tuesday!.toJson();
    if (thursday != null) json['thursday'] = thursday!.toJson();
    if (wednesday != null) json['wednesday'] = wednesday!.toJson();
    if (friday != null) json['friday'] = friday!.toJson();
    if (saturday != null) json['saturday'] = saturday!.toJson();
    return json;
  }
}

// ============================================================
// Day Schedule Class
// ============================================================
class DaySchedule {
  String? end;
  String? start;

  DaySchedule({this.end, this.start});

  DaySchedule.fromJson(Map<String, dynamic> json) {
    end = json['end'];
    start = json['start'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['end'] = end;
    json['start'] = start;
    return json;
  }
}


class User {
  int? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? gender;
  String? profilePictureUrl;

  User({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.profilePictureUrl,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    profilePictureUrl = json['profile_picture_url']; 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['full_name'] = fullName;
    json['email'] = email;
    json['phone_number'] = phoneNumber;
    json['gender'] = gender;
    json['profile_picture_url'] = profilePictureUrl;
    return json;
  }
}

// ============================================================
// Specialty Class
// ============================================================
class Specialty {
  int? id;
  String? name;
  String? description;

  Specialty({this.id, this.name, this.description});

  Specialty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['name'] = name;
    json['description'] = description;
    return json;
  }
}

// ============================================================
// Review Class
// ============================================================
class Review {
  int? id;
  int? userId;
  int? doctorId;
  int? rating;
  String? comment;
  String? createdAt;
  User? user;

  Review({
    this.id,
    this.userId,
    this.doctorId,
    this.rating,
    this.comment,
    this.createdAt,
    this.user,
  });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    doctorId = json['doctor_id'];
    rating = json['rating'];
    comment = json['comment'];
    createdAt = json['created_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['user_id'] = userId;
    json['doctor_id'] = doctorId;
    json['rating'] = rating;
    json['comment'] = comment;
    json['created_at'] = createdAt;
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }
}