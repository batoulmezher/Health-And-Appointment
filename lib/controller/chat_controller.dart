// lib/controller/chat_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/models/conversation_model.dart';
import 'package:health_appointment_app/models/message_model.dart';
import 'package:health_appointment_app/services/chat_service.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();

  var conversations = <Conversation>[].obs;
  var messages = <Message>[].obs;
  var isLoading = false.obs;
  var isSending = false.obs;
  var errorMessage = ''.obs;
  var selectedConversationId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _chatService.getConversations();
      isLoading.value = false;
      if (result != null) {
        conversations.value = result;
      } else {
        errorMessage.value = 'فشل تحميل المحادثات';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'حدث خطأ غير متوقع';
    }
  }

  Future<void> fetchMessages(String conversationId) async {
    selectedConversationId.value = conversationId;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _chatService.getMessages(conversationId);
      isLoading.value = false;
      if (result != null) {
        messages.value = result;
      } else {
        errorMessage.value = 'فشل تحميل الرسائل';
        messages.clear();
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'حدث خطأ غير متوقع';
      messages.clear();
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    if (selectedConversationId.value.isEmpty) {
      Get.snackbar('خطأ', 'لا توجد محادثة محددة');
      return;
    }

    isSending.value = true;
    try {
      final result = await _chatService.sendMessage(
        selectedConversationId.value,
        content.trim(),
      );
      isSending.value = false;
      if (result != null) {
        messages.add(result);
        final index = conversations.indexWhere((c) => c.id == selectedConversationId.value);
        if (index != -1) {
          final conv = conversations[index];
          final updatedConv = Conversation(
            id: conv.id,
            doctor: conv.doctor,
            patient: conv.patient,
            latestMessage: LatestMessage(
              id: result.id,
              conversationId: result.conversationId,
              content: result.content,
              isRead: result.isRead,
              createdAt: result.createdAt,
              timeAgo: 'الآن',
            ),
            createdAt: conv.createdAt,
          );
          conversations[index] = updatedConv;
          conversations.refresh();
        }
      } else {
        Get.snackbar('خطأ', 'فشل إرسال الرسالة');
      }
    } catch (e) {
      isSending.value = false;
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع');
    }
  }

  void stopPolling() {
  }

  @override
  void onClose() {
    stopPolling();
    super.onClose();
  }
}