// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/constant/colors.dart';
import 'package:health_appointment_app/controller/home_controller.dart';
import 'package:health_appointment_app/controller/user_controller.dart';
import 'package:health_appointment_app/models/doctor_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final controller = Get.put(HomeController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final primaryTextColor = isDarkMode ? Colors.white : appColor.primary;
    final secondaryTextColor = isDarkMode
        ? Colors.white70
        : appColor.primary.withOpacity(0.8);
    final backgroundColor = isDarkMode
        ? Colors.grey.shade900
        : const Color(0xFFF8F9FB);
    final cardColor = isDarkMode ? Colors.black : Colors.white;
    final fillColor = isDarkMode
        ? Colors.grey.shade800
        : const Color(0xFFF8F9FB);
    final hintColor = isDarkMode ? Colors.white60 : Colors.grey.shade400;

    final token = GetStorage().read('token') ?? '';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 100,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        appColor.primary,
                        appColor.primary.withBlue(30).withGreen(20),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey.shade300,
                                    child: ClipOval(
                                      child: userController.userImage.isNotEmpty
                                          ? Image.network(
                                              userController.userImage,
                                              headers: {
                                                if (token.isNotEmpty)
                                                  'Authorization': 'Bearer $token',
                                              },
                                              fit: BoxFit.cover,
                                              width: 48,
                                              height: 48,
                                              errorBuilder: (_, __, ___) => Image.network(
                                                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userController.userName)}&background=001b48&color=fff&size=150',
                                                fit: BoxFit.cover,
                                                width: 48,
                                                height: 48,
                                              ),
                                            )
                                          : Image.network(
                                              'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userController.userName)}&background=001b48&color=fff&size=150',
                                              fit: BoxFit.cover,
                                              width: 48,
                                              height: 48,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'greeting'.tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Text(
                                        userController.userName, // ✅ اسمك الحقيقي
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.notifications_active_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.notifications_none_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // ============================================================
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: controller.searchController,
                    style: TextStyle(color: primaryTextColor),
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'search_hint'.tr,
                      hintStyle: TextStyle(color: hintColor),
                      prefixIcon: Icon(Icons.tune, color: appColor.primary),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade400,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Specialties

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'specialties'.tr,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
      ),
      TextButton(
        onPressed: () => Get.toNamed(AppRoutes.specialtiesScreen),
        child: Text(
          'view_all'.tr,
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    ],
  ),
),
const SizedBox(height: 12),
Obx(() {
  if (controller.isLoading.value) {
    return const SizedBox(
      height: 100,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  if (controller.specialties.isEmpty) {
    return const SizedBox(
      height: 100,
      child: Center(
        child: Text('لا توجد تخصصات'),
      ),
    );
  }
  return SizedBox(
    height: 100,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: controller.specialties.length,
      itemBuilder: (context, index) {
        final spec = controller.specialties[index];
        return Container(
          width: 80,
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: appColor.primary),
                  boxShadow: [
                    BoxShadow(
                      color: appColor.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  controller.getIconForSpecialty(spec.name),
                  color: appColor.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                spec.name,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: appColor.primary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    ),
  );
}),
const SizedBox(height: 10),
              // Recommended Doctors
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'recommended_doctors'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.allDoctors),
                      child: Text(
                        'view_all'.tr,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Loading / Error / Data states
              Obx(() {
                if (controller.isLoading.value) {
                  return const SizedBox(
                    height: 170,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (controller.doctors.isEmpty && controller.errorMessage.isNotEmpty) {
                  return SizedBox(
                    height: 170,
                    child: Center(
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ),
                  );
                }
                if (controller.doctors.isEmpty) {
                  return SizedBox(
                    height: 170,
                    child: Center(
                      child: Text(
                        'لا يوجد أطباء حالياً',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: controller.doctors.length,
                    itemBuilder: (context, index) {
                      final doctorData = controller.doctors[index];
                      final user = doctorData.user;
                      final specialty = doctorData.specialty;
                      final name = user?.fullName ?? 'طبيب';
                      final specialtyName = specialty?.name ?? 'تخصص غير معروف';
                      final rating = doctorData.ratingAverage ?? '0.0';
                      final price = doctorData.consultationFee ?? '0';
                      final imageUrl = _getDoctorImage(user);
                      final availableTime = _formatWorkingHours(doctorData.workingDaysHours);

                      return Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                imageUrl,
                                headers: {
                                  if (token.isNotEmpty)
                                    'Authorization': 'Bearer $token',
                                },
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade300,
                                  child: Center(
                                    child: Text(
                                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Gradient overlay
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isDarkMode
                                          ? [
                                              appColor.primary.withOpacity(0.9),
                                              Colors.transparent,
                                            ]
                                          : [
                                              appColor.primary.withOpacity(0.9),
                                              Colors.transparent,
                                            ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                              // Content
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 4,
                                            color: Colors.black38,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      specialtyName,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 3,
                                            color: Colors.black38,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 10,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              rating,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${double.tryParse(price)?.toInt() ?? price} ل.س',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 3,
                                                color: Colors.black38,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.25),
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Text(
                                            'book'.tr,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (availableTime.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          availableTime,
                                          style: const TextStyle(
                                            fontSize: 8,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 10),
              // Latest posts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'latest_posts'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: controller.recentPosts.length,
                itemBuilder: (context, index) {
                  final post = controller.recentPosts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      post.doctorImageUrl,
                                    ),
                                    onBackgroundImageError: (_, __) {},
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.doctorName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryTextColor,
                                          ),
                                        ),
                                        Text(
                                          post.timeAgo,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.more_horiz,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                post.content,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(24),
                          ),
                          child: Image.network(
                            post.imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 180,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image_outlined,
                                color: Colors.grey,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    post.likes.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.comment_outlined,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    post.comments.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(
                                Icons.share_outlined,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 80),
            ]),
          ),
        ],
      ),
    );
  }

  String _getDoctorImage(User? user) {
    final imageUrl = user?.profilePictureUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';
    }
    final name = user?.fullName ?? 'طبيب';
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=001b48&color=fff&size=150';
  }

  String _formatWorkingHours(WorkingDaysHours? hours) {
    if (hours == null) return '';
    final day = hours.monday ?? hours.sunday ?? hours.tuesday ?? hours.wednesday ?? hours.thursday;
    if (day != null && day.start != null && day.end != null) {
      return '${day.start} - ${day.end}';
    }
    return '';
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height,
      size.width * 0.35,
      size.height - 25,
    );
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height - 50,
      size.width * 0.75,
      size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height - 5,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}