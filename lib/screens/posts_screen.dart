// lib/screens/posts_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/controller/posts_controller.dart';
import 'package:health_appointment_app/widgets/post_card.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostsController());
    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode ? Colors.grey.shade900 : const Color(0xFFF8F9FB);
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF6B7280);
    final commentBgColor = isDarkMode ? Colors.grey.shade800.withOpacity(0.3) : Colors.grey.shade100;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'All Posts',
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: textColor),
            onPressed: () => controller.fetchAllPosts(),
          ),
        ],
      ),
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
                  onPressed: controller.fetchAllPosts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (controller.posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.post_add, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No posts available',
                  style: TextStyle(color: subTextColor, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Follow doctors to see their posts here',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchAllPosts,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              return PostCard(
                post: post,
                index: index,
                controller: controller,
                cardColor: cardColor,
                textColor: textColor,
                subTextColor: subTextColor,
                commentBgColor: commentBgColor,
              );
            },
          ),
        );
      }),
    );
  }
}