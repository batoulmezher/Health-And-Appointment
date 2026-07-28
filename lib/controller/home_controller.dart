// lib/controller/home_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/controller/posts_controller.dart';
import 'package:health_appointment_app/models/doctor_model.dart';
import 'package:health_appointment_app/models/post_model.dart';
import 'package:health_appointment_app/models/specialty_model.dart';
import 'package:health_appointment_app/services/home_service.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();
  final HomeService _homeService = HomeService();

  final PostsController postsController = PostsController();

  var doctors = <Data>[].obs;
  var specialties = <SpecialtyModel>[].obs;
  var latestPosts = <PostModel>[].obs;

  var searchResults = <Data>[].obs;
  var isSearching = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  // ============================================================
  Future<void> fetchAllData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await Future.wait([
        _homeService.getHomeDoctors(),
        _homeService.getHomeSpecialties(),
        _homeService.getLatestPosts(),
      ]);

      if (results[0] != null && results[0] is List) {
        doctors.value = results[0] as List<Data>;
      }
      if (results[1] != null && results[1] is List) {
        specialties.value = results[1] as List<SpecialtyModel>;
        print("✅ Specialties loaded: ${specialties.length}");
      }
      if (results[2] != null && results[2] is List) {
        final posts = results[2] as List<PostModel>;
        latestPosts.value = posts;
        postsController.setPosts(posts);
        print("✅ Posts loaded: ${posts.length}");
        for (var post in posts) {
          print("📊 Post ID: ${post.id}, Comments: ${post.commentsCount}");
        }
      }

      if (doctors.isEmpty && specialties.isEmpty && latestPosts.isEmpty) {
        errorMessage.value = 'لا توجد بيانات حالياً';
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء تحميل البيانات';
      print("❌ Home fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    try {
      print("🔍 Searching for: $query");
      final results = await _homeService.searchDoctors(query.trim());
      print("📊 Search results: ${results?.length ?? 0}");
      if (results != null && results.isNotEmpty) {
        searchResults.value = results;
        print("✅ Results stored: ${searchResults.length}");
      } else {
        searchResults.clear();
        print("❌ No results found");
      }
    } catch (e) {
      print("❌ Search error: $e");
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    isSearching.value = false;
    _debounceTimer?.cancel();
  }

  List<Data> get displayedDoctors {
    return isSearching.value || searchResults.isNotEmpty
        ? searchResults
        : doctors;
  }

  void getDoctor(int id) async {
    final results = await _homeService.getDoctorById(id);
  }

  String getTimeAgo(DateTime dateTime) {
    return postsController.getTimeAgo(dateTime);
  }

  String getTimeAgoFromPost(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 365) {
      return 'منذ ${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return 'منذ ${(difference.inDays / 30).floor()} شهر';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  // ============================================================
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
   // _debounceTimer?.cancel();
  //  searchController.dispose();
    super.onClose();
  }
}