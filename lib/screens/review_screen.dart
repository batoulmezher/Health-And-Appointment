// lib/screens/review_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/review_controller.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final doctorId = args?['doctorId'] ?? 0;
    final doctorName = args?['doctorName'] ?? 'طبيب';
    final specialtyName = args?['specialtyName'] ?? 'تخصص غير معروف';
    final doctorImage = args?['doctorImage'];
    final rating = args?['rating'] ?? 0.0;
    final reviewsCount = args?['reviewsCount'] ?? 0;

    final controller = Get.put(
      ReviewController(
        doctorId: doctorId,
        doctorName: doctorName,
        specialtyName: specialtyName,
        doctorImage: doctorImage,
        rating: rating,
        reviewsCount: reviewsCount,
      ),
    );

    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode
        ? const Color(0xFF0F0F1A)
        : const Color(0xFFF0F2F8);
    final cardColor = isDarkMode ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'تقييم الطبيب',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== بطاقة الطبيب =====
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage:
                        doctorImage != null && doctorImage.isNotEmpty
                        ? NetworkImage(doctorImage)
                        : const NetworkImage(
                            'https://ui-avatars.com/api/?name=Doctor&background=001b48&color=fff&size=150',
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          specialtyName,
                          style: TextStyle(fontSize: 14, color: subTextColor),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              ' ($reviewsCount تقييم)',
                              style: TextStyle(
                                fontSize: 14,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ما هو تقييمك العام للخدمة؟',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final ratingValue = index + 1;
                        return GestureDetector(
                          onTap: () => controller.setRating(ratingValue),
                          child: Obx(() {
                            final isSelected =
                                controller.selectedRating.value >= ratingValue;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                isSelected ? Icons.star : Icons.star_border,
                                color: isSelected
                                    ? Colors.amber
                                    : Colors.grey.shade400,
                                size: 40,
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Obx(() {
                      final rating = controller.selectedRating.value;
                      if (rating == 0) {
                        return Text(
                          'اضغط لتقييم تجربتك',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        );
                      }
                      return Text(
                        controller.getRatingLabel(rating),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: appColor.appColor.primary,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختر ما يناسب تجربتك',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(controller.quickOptions.length, (index) {
                    final option = controller.quickOptions[index];
                    return Obx(() {
                      final isSelected = controller.selectedQuickOptions[index];
                      return GestureDetector(
                        onTap: () => controller.toggleQuickOption(index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? appColor.appColor.primary.withOpacity(0.08)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? appColor.appColor.primary
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                option.icon,
                                color: isSelected
                                    ? appColor.appColor.primary
                                    : Colors.grey.shade500,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option.label,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isSelected
                                        ? textColor
                                        : subTextColor,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: appColor.appColor.primary,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    });
                  }),
                  Obx(() {
                    final selectedText = controller.getSelectedQuickOptions();
                    if (selectedText.isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '✅ $selectedText',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green.shade700,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'رأيك بالتفصيل',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 5,
                    onChanged: controller.updateComment,
                    decoration: InputDecoration(
                      hintText: 'شاركنا تفاصيل تجربتك مع الطبيب...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade50,
                      contentPadding: const EdgeInsets.all(16),
                      counterText: '',
                    ),
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'هل تنصح بالتعامل مع هذا الطبيب؟',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final rating = controller.selectedRating.value;
                    return Row(
                      children: [
                        Expanded(
                          child: _buildRecommendButton(
                            label: 'نعم، بالتأكيد',
                            isSelected: rating >= 4,
                            color: Colors.green,
                            onTap: () {
                              if (rating < 4) controller.setRating(4);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildRecommendButton(
                            label: 'لا أنصح',
                            isSelected: rating <= 2 && rating > 0,
                            color: Colors.red,
                            onTap: () {
                              if (rating > 2 || rating == 0)
                                controller.setRating(2);
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: Obx(() {
                return ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () async {
                          final success = await controller.submitReview();
                          if (success) {
                            Get.back(result: true);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColor.appColor.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: appColor.appColor.primary.withOpacity(0.3),
                  ),
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'إرسال التقييم',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield, color: Colors.grey.shade600, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'سيتم مراجعة تقييمك لضمان جودة المحتوى وفقاً لمعايير Clinical.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendButton({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? color : Colors.grey.shade500,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
