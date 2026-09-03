// lib/screens/chat/messages_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/constant/imagesRoute.dart';
import 'package:health_appointment_app/controller/chat_controller.dart';
import 'package:health_appointment_app/models/message_model.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    final isDarkMode = Get.isDarkMode;

    final arguments = Get.arguments as Map<String, dynamic>?;
    final conversationId = arguments?['conversationId'] ?? '';
    final doctorName = arguments?['doctorName'] ?? 'طبيب';
    final doctorImage = arguments?['doctorImage'];

    final backgroundColor = isDarkMode
        ? const Color(0xFF0A0A0A)
        : const Color(0xFFECE5DD);

    final TextEditingController messageController = TextEditingController();
    final ScrollController scrollController = ScrollController();

  WidgetsBinding.instance.addPostFrameCallback((_) {
  if (conversationId.isNotEmpty) {
    controller.selectedConversationId.value = conversationId;
    controller.fetchMessages(conversationId).then((_) {
      controller.startPolling();
    });
  }
});

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildWhatsAppAppBar(doctorName, doctorImage),
      body: Stack(
        children: [
          
          Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          appColor.appColor.primary,
                        ),
                      ),
                    );
                  }
                  if (controller.messages.isEmpty) {
                    return _buildEmptyState();
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });

                  final groupedMessages = _groupMessagesByDate(
                    controller.messages,
                  );

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    itemCount: groupedMessages.length,
                    itemBuilder: (context, index) {
                      final dateKey = groupedMessages.keys.elementAt(index);
                      final messages = groupedMessages[dateKey]!;
                      return Column(
                        children: [
                          _buildDateHeader(dateKey),
                          const SizedBox(height: 4),
                          ...messages.map(
                            (msg) => _buildMessageBubble(msg, isDarkMode),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
              _buildWhatsAppInputArea(
                controller,
                messageController,
                isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildWhatsAppAppBar(String name, String? image) {
    return AppBar(
      backgroundColor: appColor.appColor.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: image != null && image.isNotEmpty
                ? NetworkImage(image)
                : const NetworkImage(
                    'https://ui-avatars.com/api/?name=Doctor&background=001b48&color=fff&size=150',
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'متصل الآن',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: appColor.appColor.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد رسائل بعد',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أرسل رسالتك الأولى!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Map<String, List<Message>> _groupMessagesByDate(List<Message> messages) {
    final Map<String, List<Message>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final msg in messages) {
      final date = DateTime(
        msg.createdAt.year,
        msg.createdAt.month,
        msg.createdAt.day,
      );
      String key;
      if (date == today) {
        key = 'اليوم';
      } else if (date == today.subtract(const Duration(days: 1))) {
        key = 'أمس';
      } else {
        key = DateFormat('dd MMM yyyy', 'ar').format(date);
      }
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(msg);
    }
    return grouped;
  }

  Widget _buildDateHeader(String dateKey) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        dateKey,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isDark) {
    final isUser = message.isFromUser;

    final Color bubbleColor = isUser
        ? appColor.appColor.primary
        : (isDark ? Colors.grey.shade800 : Colors.white);
    final Color textColor = isUser
        ? Colors.white
        : (isDark ? Colors.white : Colors.black);
    final Color timeColor = isUser
        ? Colors.white70
        : (isDark ? Colors.grey.shade500 : Colors.grey.shade600);
    final Alignment alignment = isUser
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final BorderRadius borderRadius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
          );

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: Get.width * 0.78),
        child: Material(
          elevation: isUser ? 1 : 0.5,
          shadowColor: Colors.black.withOpacity(0.06),
          borderRadius: borderRadius,
          color: bubbleColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (message.imageUrl != null && message.imageUrl!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      message.imageUrl!,
                      width: 180,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          width: 180,
                          height: 120,
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        width: 180,
                        height: 120,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  if (message.content.isNotEmpty) const SizedBox(height: 6),
                ],
                if (message.content.isNotEmpty)
                  Text(
                    message.content,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.createdAt),
                      style: TextStyle(color: timeColor, fontSize: 10),
                    ),
                    if (isUser && message.isRead) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.done_all,
                        size: 14,
                        color: Colors.white70,
                      ),
                    ] else if (isUser) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.done, size: 14, color: Colors.white60),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWhatsAppInputArea(
    ChatController controller,
    TextEditingController textController,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.selectedImage != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            controller.selectedImage!,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: -4,
                          top: -4,
                          child: GestureDetector(
                            onTap: controller.clearSelectedImage,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'صورة مرفقة',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.grey.shade600),
                  onPressed: controller.isSending.value
                      ? null
                      : controller.pickImage,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالة...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          controller.sendMessage(content: value.trim());
                          textController.clear();
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: const BoxDecoration(
                    color: appColor.appColor.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: controller.isSending.value
                          ? Colors.grey.shade300
                          : Colors.white,
                      size: 20,
                    ),
                    onPressed: controller.isSending.value
                        ? null
                        : () {
                            final text = textController.text;
                            final image = controller.selectedImage;
                            if (text.trim().isNotEmpty || image != null) {
                              controller.sendMessage(
                                content: text.trim().isNotEmpty
                                    ? text.trim()
                                    : null,
                                imageFile: image,
                              );
                              textController.clear();
                            } else {
                              Get.snackbar(
                                'تنبيه',
                                'يرجى كتابة نص أو اختيار صورة',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange.shade100,
                                colorText: Colors.orange.shade900,
                              );
                            }
                          },
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a', 'ar').format(dateTime);
  }
}