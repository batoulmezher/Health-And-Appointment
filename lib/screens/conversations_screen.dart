// lib/screens/chat/conversations_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/chat_controller.dart';
import 'package:health_appointment_app/models/conversation_model.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode ? Colors.grey.shade900 : const Color(0xFFF8F9FB);
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'المحادثات',
          style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: textColor),
            onPressed: controller.fetchConversations,
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
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchConversations,
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        if (controller.conversations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'لا توجد محادثات',
                  style: TextStyle(color: subTextColor, fontSize: 16),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchConversations,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.conversations.length,
            itemBuilder: (context, index) {
              final conversation = controller.conversations[index];
              return _buildConversationCard(conversation, controller, cardColor, textColor, subTextColor);
            },
          ),
        );
      }),
    );
  }

  Widget _buildConversationCard(
    Conversation conversation,
    ChatController controller,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    final currentUserId = GetStorage().read('user_id') ?? 0;
    final isDoctor = conversation.doctor.id == currentUserId;
    final otherUser = isDoctor ? conversation.patient : conversation.doctor;

    final otherName = otherUser.fullName ?? 'مستخدم';
    final otherImage = otherUser.profilePictureUrl;

    final lastMessage = conversation.latestMessage?.content ?? 'ابدأ المحادثة...';
    final timeAgo = conversation.latestMessage?.timeAgo ?? '';

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.chatMessages,
          arguments: {
            'conversationId': conversation.id,
            'doctorName': otherName,
            'doctorImage': otherImage,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: otherImage != null && otherImage.isNotEmpty
                  ? NetworkImage(otherImage)
                  : const NetworkImage('https://ui-avatars.com/api/?name=User&background=001b48&color=fff&size=150'),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: subTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (timeAgo.isNotEmpty)
              Text(
                timeAgo,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}