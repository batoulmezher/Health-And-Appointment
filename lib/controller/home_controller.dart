import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/models/doctor_model.dart';
import 'package:health_appointment_app/models/post_model.dart';
import 'package:health_appointment_app/models/specialty_model.dart';
import 'package:health_appointment_app/services/home_service.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();
  final HomeService _homeService = HomeService();

  var doctors = <Data>[].obs;
  var specialties = <SpecialtyModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

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
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await Future.wait([
        _homeService.getDoctors(),
        _homeService.getHomeSpecialties(),
      ]);

      if (results[0] != null && results[0] is List) {
        doctors.value = results[0] as List<Data>;
      }

      if (results[1] != null && results[1] is List) {
        specialties.value = results[1] as List<SpecialtyModel>;
        print("✅ Specialties loaded: ${specialties.length}");
      }

      if (doctors.isEmpty && specialties.isEmpty) {
        errorMessage.value = 'لا توجد بيانات حالياً';
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء تحميل البيانات';
      print("❌ Home fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  IconData getIconForSpecialty(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('cardio')) return Icons.favorite;
    if (lowerName.contains('derma')) return Icons.spa;
    if (lowerName.contains('neuro')) return Icons.psychology;
    if (lowerName.contains('ophthal')) return Icons.visibility;
    if (lowerName.contains('pediat')) return Icons.child_care;
    if (lowerName.contains('ortho')) return Icons.accessibility_new;
    if (lowerName.contains('psych')) return Icons.mood;
    if (lowerName.contains('dent')) return Icons.medical_services;
    if (lowerName.contains('ent')) return Icons.hearing;
    if (lowerName.contains('general')) return Icons.local_hospital;
    return Icons.medical_services;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}