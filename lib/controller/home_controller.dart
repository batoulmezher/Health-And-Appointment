import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/doctor_model.dart';
import '../models/post_model.dart';
import '../models/specialization_model.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();

  final List<Specialization> specializations = [
    Specialization(name: "العقل", icon: Icons.psychology),
    Specialization(name: "الأسنان", icon: Icons.medical_services),
    Specialization(name: "الأطفال", icon: Icons.child_care),
    Specialization(name: "الباطنية", icon: Icons.healing),
  ];

  final List<Doctor> recommendedDoctors = [
    Doctor(
      name: "د. أحمد خالد",
      specialty: "جراحة العظام",
      rating: 4.9,
      price: 150000,
      imageUrl: "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&h=400&fit=crop&crop=face",
      availableTime: "8:00 ص - 2:00 م",
      gender: "ذكر",
      governorate: "دمشق",
    ),
    Doctor(
      name: "د. سارة المنصوري",
      specialty: "طب الأطفال",
      rating: 4.8,
      price: 200000,
      imageUrl: "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face",
      availableTime: "10:00 ص - 4:00 م",
      gender: "أنثى",
      governorate: "حلب",
    ),
    Doctor(
      name: "د. ماجد السيد",
      specialty: "جراحة القلب",
      rating: 4.7,
      price: 180000,
      imageUrl: "https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&h=400&fit=crop&crop=face",
      availableTime: "9:00 ص - 3:00 م",
      gender: "ذكر",
      governorate: "دمشق",
    ),
    Doctor(
      name: "د. ليلى حسن",
      specialty: "الجلدية",
      rating: 4.9,
      price: 160000,
      imageUrl: "https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=400&h=400&fit=crop&crop=face",
      availableTime: "11:00 ص - 5:00 م",
      gender: "أنثى",
      governorate: "حمص",
    ),
    Doctor(
      name: "د. خالد العتيبي",
      specialty: "الأعصاب",
      rating: 4.6,
      price: 220000,
      imageUrl: "https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&h=400&fit=crop&crop=face",
      availableTime: "1:00 م - 7:00 م",
      gender: "ذكر",
      governorate: "اللاذقية",
    ),
  ];

  final List<Post> recentPosts = [
    Post(
      doctorName: "د. عمر النيوتف",
      doctorImageUrl: "https://i.pravatar.cc/150?img=3",
      content: "أهمية شرب الماء بانتظام خلال فصل الصيف لتجنب الجفاف والحفاظ على نضارة البشر، ننصح بشرب ما لا يقل عن 8 أكواب يومياً.",
      timeAgo: "منذ ساعتين",
      likes: 85,
      comments: 1200,
      imageUrl: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600&h=400&fit=crop",
    ),
  ];

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}