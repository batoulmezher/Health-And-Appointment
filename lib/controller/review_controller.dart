// lib/controller/review_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/models/review.dart';
import 'package:health_appointment_app/services/review_service.dart';

class ReviewController extends GetxController {
  final ReviewService _reviewService = ReviewService();

  final int doctorId;
  final String doctorName;
  final String specialtyName;
  final String? doctorImage;
  final double rating;
  final int reviewsCount;

  var selectedRating = 0.obs;
  var comment = ''.obs;
  var isSubmitting = false.obs;
  var errorMessage = ''.obs;

  final List<QuickRatingOption> quickOptions = [
    QuickRatingOption(icon: Icons.access_time, label: 'دقة المواعيد'),
    QuickRatingOption(icon: Icons.psychology, label: 'احترافية عالية'),
    QuickRatingOption(icon: Icons.description, label: 'شرح واضح'),
    QuickRatingOption(icon: Icons.cleaning_services, label: 'نظافة العيادة'),
    QuickRatingOption(icon: Icons.hearing, label: 'استماع جيد'),
  ];

  var selectedQuickOptions = <bool>[].obs;

  ReviewController({
    required this.doctorId,
    required this.doctorName,
    required this.specialtyName,
    this.doctorImage,
    required this.rating,
    required this.reviewsCount,
  }) {
    selectedQuickOptions.value = List.filled(quickOptions.length, false);
  }

  void setRating(int value) => selectedRating.value = value;
  void toggleQuickOption(int index) {
    selectedQuickOptions[index] = !selectedQuickOptions[index];
    selectedQuickOptions.refresh();
  }
  void updateComment(String value) => comment.value = value;

  String getRatingLabel(int rating) {
    switch (rating) {
      case 1: return 'ضعيف جداً';
      case 2: return 'ضعيف';
      case 3: return 'جيد';
      case 4: return 'جيد جداً';
      case 5: return 'ممتاز';
      default: return '';
    }
  }

  String getSelectedQuickOptions() {
    final selected = <String>[];
    for (int i = 0; i < quickOptions.length; i++) {
      if (selectedQuickOptions[i]) selected.add(quickOptions[i].label);
    }
    return selected.join('، ');
  }

  Future<bool> submitReview() async {
    if (selectedRating.value == 0) {
      Get.snackbar('تنبيه', 'يرجى اختيار تقييم بالنجوم');
      return false;
    }
    if (comment.value.trim().isEmpty) {
      Get.snackbar('تنبيه', 'يرجى كتابة رأيك بالتفصيل');
      return false;
    }

    isSubmitting.value = true;
    errorMessage.value = '';

    try {
      final result = await _reviewService.submitReview(
        doctorId: doctorId,
        ratingScore: selectedRating.value,
        comment: comment.value.trim(),
      );

      isSubmitting.value = false;

      if (result != null) {
        Get.snackbar(
          'شكراً لك!',
          'تم إرسال تقييمك بنجاح. سيتم مراجعته قريباً.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          duration: const Duration(seconds: 4),
        );
        return true;
      } else {
        errorMessage.value = 'فشل إرسال التقييم، يرجى المحاولة لاحقاً';
        Get.snackbar('خطأ', errorMessage.value);
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      errorMessage.value = 'حدث خطأ غير متوقع';
      Get.snackbar('خطأ', errorMessage.value);
      return false;
    }
  }
}

class QuickRatingOption {
  final IconData icon;
  final String label;
  QuickRatingOption({required this.icon, required this.label});
}