// lib/screens/doctor_profile_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/doctor_profile_controller.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorProfileController());
    final isDarkMode = Get.isDarkMode;
    final screenHeight = MediaQuery.of(context).size.height;

    final backgroundColor = isDarkMode ? Colors.grey.shade900 : const Color(0xFFF8F9FB);
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : appColor.appColor.primary;
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF44464F);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: subTextColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final int? id = Get.arguments as int?;
                    if (id != null) controller.fetchDoctorDetails(id);
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        if (controller.doctorData.value == null) {
          return Center(
            child: Text(
              'لا توجد بيانات للطبيب',
              style: TextStyle(color: subTextColor),
            ),
          );
        }

        final doctorData = controller.doctorData.value!;
        final user = doctorData.user;
        final name = user?.fullName ?? 'طبيب';
        final specialtyName = doctorData.specialty?.name ?? 'تخصص غير معروف';
        final rating = doctorData.ratingAverage ?? '0.0';
        final bio = doctorData.bio ?? 'لا يوجد وصف';
        final experience = doctorData.yearsOfExperience ?? 0;
        final clinicLocation = doctorData.clinicLocation ?? 'غير محدد';
        final city = doctorData.city ?? 'غير محدد';
        final consultationFee = doctorData.consultationFee ?? '0';
        final status = doctorData.status ?? 'غير معروف';
        final imageUrl = user?.profilePictureUrl ?? '';
        final email = user?.email ?? 'غير متوفر';
        final phone = user?.phoneNumber ?? 'غير متوفر';
        final gender = user?.gender == 'M' ? 'ذكر' : (user?.gender == 'F' ? 'أنثى' : 'غير محدد');

        return CustomScrollView(
          slivers: [
            // ---- AppBar with Photo ----
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: screenHeight * 0.4,
              pinned: false,
              floating: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl.isNotEmpty
                          ? imageUrl
                          : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=001b48&color=fff&size=256',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade300,
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              specialtyName,
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 8, color: Colors.black38, offset: Offset(0, 2)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: status == 'APPROVED'
                                  ? Colors.green.withOpacity(0.8)
                                  : Colors.orange.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status == 'APPROVED' ? '✅ معتمد' : '⏳ قيد المراجعة',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // ---- TabBar ----
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Obx(
                        () => Row(
                          children: [
                            _buildTabButton(
                              label: 'professional_profile'.tr,
                              isSelected: controller.selectedTab.value == 0,
                              onTap: () => controller.selectTab(0),
                            ),
                            const SizedBox(width: 12),
                            _buildTabButton(
                              label: 'doctor_posts'.tr,
                              isSelected: controller.selectedTab.value == 1,
                              onTap: () => controller.selectTab(1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => IndexedStack(
                        index: controller.selectedTab.value,
                        children: [
                          _buildDetailsTab(controller, cardColor, textColor, subTextColor),
                          _buildPostsTab(cardColor, textColor, subTextColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? appColor.appColor.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? appColor.appColor.primary : Colors.grey.shade500,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsTab(
    DoctorProfileController controller,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    final doctorData = controller.doctorData.value!;
    final user = doctorData.user;

    final name = user?.fullName ?? 'طبيب';
    final rating = doctorData.ratingAverage ?? '0.0';
    final bio = doctorData.bio ?? 'لا يوجد وصف';
    final experience = doctorData.yearsOfExperience ?? 0;
    final clinicLocation = doctorData.clinicLocation ?? 'غير محدد';
    final city = doctorData.city ?? 'غير محدد';
    final consultationFee = doctorData.consultationFee ?? '0';
    final status = doctorData.status ?? 'غير معروف';
    final email = user?.email ?? 'غير متوفر';
    final phone = user?.phoneNumber ?? 'غير متوفر';
    final gender = user?.gender == 'M' ? 'ذكر' : (user?.gender == 'F' ? 'أنثى' : 'غير محدد');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ---- Main Info Card ----
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // ---- Bio ----
                if (bio.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: subTextColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'السيرة الذاتية',
                          style: TextStyle(
                            fontSize: 14,
                            color: subTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bio,
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ---- Info Chips ----
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.verified_outlined,
                      label: 'الخبرة',
                      value: '$experience سنة',
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      icon: Icons.star,
                      label: 'التقييم',
                      value: '$rating ★',
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      icon: Icons.attach_money,
                      label: 'الكشفية',
                      value: '${double.tryParse(consultationFee)?.toInt() ?? consultationFee} ل.س',
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ---- Details (full width) ----
                _buildFullWidthDetail(
                  icon: Icons.email_outlined,
                  label: 'البريد الإلكتروني',
                  value: email,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                const SizedBox(height: 12),
                _buildFullWidthDetail(
                  icon: Icons.phone_outlined,
                  label: 'رقم الهاتف',
                  value: phone,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                const SizedBox(height: 12),
                _buildFullWidthDetail(
                  icon: Icons.person_outline,
                  label: 'الجنس',
                  value: gender,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                const SizedBox(height: 12),
                _buildFullWidthDetail(
                  icon: Icons.location_on_outlined,
                  label: 'العيادة',
                  value: clinicLocation,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                const SizedBox(height: 12),
                _buildFullWidthDetail(
                  icon: Icons.location_city,
                  label: 'المدينة',
                  value: city,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                const SizedBox(height: 16),

                // ---- Status ----
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: status == 'APPROVED'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: status == 'APPROVED'
                          ? Colors.green.withOpacity(0.3)
                          : Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        status == 'APPROVED' ? Icons.check_circle : Icons.pending,
                        color: status == 'APPROVED' ? Colors.green : Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status == 'APPROVED' ? '✅ معتمد' : '⏳ قيد المراجعة',
                        style: TextStyle(
                          color: status == 'APPROVED' ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ---- Follow / Chat / Star buttons with follow integration ----
                Row(
                  children: [
                    Obx(() {
                      return Expanded(
                        child: ElevatedButton.icon(
                          onPressed: controller.isFollowLoading.value
                              ? null
                              : controller.toggleFollow,
                          icon: controller.isFollowLoading.value
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  controller.isFollowing.value
                                      ? Icons.person_remove
                                      : Icons.person_add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                          label: Text(
                            controller.isFollowing.value
                                ? 'إلغاء المتابعة'
                                : 'follow'.tr,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColor.appColor.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.chat, color: appColor.appColor.primary),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.star, color: appColor.appColor.primary),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ---- 📅 SECTION 1: WORKING DAYS & HOURS ----
          _buildWorkingDaysSection(controller, cardColor, textColor, subTextColor),

          const SizedBox(height: 16),

          // ---- 📆 SECTION 2: AVAILABLE APPOINTMENTS ----
          _buildAppointmentsSection(controller, cardColor, textColor, subTextColor),

          const SizedBox(height: 16),

          // ---- Reviews ----
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'patient_reviews'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                if (doctorData.reviews != null && doctorData.reviews!.isNotEmpty) ...[
                  ...doctorData.reviews!.map((review) => _buildReviewCard(
                    name: review.user?.fullName ?? 'مريض',
                    date: review.createdAt ?? '',
                    rating: review.rating ?? 5,
                    comment: review.comment ?? '',
                    cardColor: cardColor,
                    textColor: textColor,
                    subTextColor: subTextColor,
                  )).toList(),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: subTextColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'لا توجد مراجعات حالياً',
                        style: TextStyle(color: subTextColor),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ---- 📅 SECTION 1: WORKING DAYS & HOURS ----
  Widget _buildWorkingDaysSection(
    DoctorProfileController controller,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: appColor.appColor.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'أيام وأوقات العمل',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          Obx(() {
            if (controller.dayNames.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: subTextColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'لا توجد أيام عمل محددة',
                    style: TextStyle(
                      fontSize: 16,
                      color: subTextColor,
                    ),
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.dayNames.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final dayName = controller.dayNames[index];
                final schedule = controller.workingDaysList[index];
                final start = schedule?.start ?? 'غير محدد';
                final end = schedule?.end ?? 'غير محدد';

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Text(
                          dayName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: appColor.appColor.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: appColor.appColor.primary.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: appColor.appColor.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$start - $end',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: appColor.appColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // ---- 📆 SECTION 2: AVAILABLE APPOINTMENTS ----
  Widget _buildAppointmentsSection(
    DoctorProfileController controller,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'available_appointments'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'أكتوبر 2023',
                    style: TextStyle(fontSize: 14, color: subTextColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (index) {
                final days = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];
                final numbers = ['16', '17', '18', '19', '20'];
                final isSelected = index == 0;
                return Container(
                  width: 68,
                  height: 76,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? appColor.appColor.primary : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        days[index],
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        numbers[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : textColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              controller.timeSlots.length,
              (index) => _buildTimeSlot(
                controller.timeSlots[index],
                controller.selectedTimeIndex.value == index,
                controller,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
          onPressed: () {
  final doctorId = controller.doctorData.value?.id;
  if (doctorId != null) {
    Get.toNamed(
      AppRoutes.appointmentScreen,
      arguments: {'doctorId': doctorId},
    );
  } else {
    Get.snackbar('خطأ', 'معرّف الطبيب غير موجود');
  }
},
              style: ElevatedButton.styleFrom(
                backgroundColor: appColor.appColor.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'book_now'.tr,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Info Chip ----
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: subTextColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: appColor.appColor.primary),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: subTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Full Width Detail ----
  Widget _buildFullWidthDetail({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: appColor.appColor.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: appColor.appColor.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: subTextColor, fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---- Time Slot ----
  Widget _buildTimeSlot(
    String time,
    bool isSelected,
    DoctorProfileController controller,
  ) {
    return GestureDetector(
      onTap: () {
        final index = controller.timeSlots.indexOf(time);
        controller.selectTime(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? appColor.appColor.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? appColor.appColor.primary : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : appColor.appColor.primary,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ---- Review Card ----
  Widget _buildReviewCard({
    required String name,
    required String date,
    required int rating,
    required String comment,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: appColor.appColor.primary.withOpacity(0.1),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: appColor.appColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                    ),
                    Text(
                      date,
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  rating,
                  (_) => const Icon(Icons.star, color: Colors.amber, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: TextStyle(fontSize: 14, color: subTextColor, height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ---- Posts Tab ----
  Widget _buildPostsTab(Color cardColor, Color textColor, Color subTextColor) {
    final List<Map<String, String>> posts = [
      {
        'title': 'أهمية شرب الماء للقلب',
        'description': 'ينصح بشرب 8 أكواب من الماء يومياً للحفاظ على صحة القلب والوقاية من الجفاف.',
        'image': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600&h=400&fit=crop',
        'date': 'منذ يومين',
      },
      {
        'title': 'الغذاء الصحي للقلب',
        'description': 'تناول الخضروات والفواكه الطازجة والبروتينات الخالية من الدهون للحفاظ على قلب سليم.',
        'image': 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600&h=400&fit=crop',
        'date': 'منذ 5 أيام',
      },
      {
        'title': 'الرياضة وصحة القلب',
        'description': 'المشي 30 دقيقة يومياً يقلل من خطر أمراض القلب بنسبة 30% ويحسن الدورة الدموية.',
        'image': 'https://images.unsplash.com/photo-1535914254981-b5012eebbd15?w=600&h=400&fit=crop',
        'date': 'منذ أسبوع',
      },
      {
        'title': 'الضغط النفسي وصحة القلب',
        'description': 'التوتر والضغط النفسي يؤثران سلباً على صحة القلب. تعلم تقنيات الاسترخاء والتنفس العميق.',
        'image': 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=600&h=400&fit=crop',
        'date': 'منذ أسبوعين',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'all_posts'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'view_all'.tr,
                  style: TextStyle(
                    color: appColor.appColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(
                        post['image']!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 180,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, color: Colors.grey, size: 48),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post['description']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: subTextColor,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                post['date']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'read_more'.tr,
                                  style: TextStyle(
                                    color: appColor.appColor.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}