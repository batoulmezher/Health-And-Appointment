// lib/controller/chat_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/models/conversation_model.dart';
import 'package:health_appointment_app/models/message_model.dart';
import 'package:health_appointment_app/services/chat_service.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final ImagePicker _imagePicker = ImagePicker();

  var conversations = <Conversation>[].obs;
  var messages = <Message>[].obs;
  var isLoading = false.obs;
  var isSending = false.obs;
  var errorMessage = ''.obs;
  var selectedConversationId = ''.obs;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  void startPolling() {
    stopPolling();
    if (selectedConversationId.value.isEmpty) return;
    _pollMessages();
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (selectedConversationId.value.isNotEmpty) {
        _pollMessages();
      }
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _pollMessages() async {
    if (selectedConversationId.value.isEmpty) return;
    try {
      final result = await _chatService.getMessages(selectedConversationId.value);
      if (result != null) {
        messages.value = result;
      }
    } catch (e) {
    }
  }

  Future<void> fetchConversations() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _chatService.getConversations();
      isLoading.value = false;
      if (result != null) {
        conversations.value = result;
        if (result.isEmpty) {
          errorMessage.value = 'لا توجد محادثات';
        }
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
        if (result.isEmpty) {
          errorMessage.value = 'لا توجد رسائل بعد';
        }
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

  Future<void> sendMessage({String? content, File? imageFile}) async {
    final hasContent = (content != null && content.trim().isNotEmpty);
    final hasImage = imageFile != null;
    if (!hasContent && !hasImage) {
      Get.snackbar('تنبيه', 'يرجى كتابة نص أو اختيار صورة');
      return;
    }
    if (selectedConversationId.value.isEmpty) {
      Get.snackbar('خطأ', 'لا توجد محادثة محددة');
      return;
    }

    isSending.value = true;
    try {
      final result = await _chatService.sendMessage(
        conversationId: selectedConversationId.value,
        content: hasContent ? content!.trim() : null,
        imageFile: hasImage ? imageFile : null,
      );
      isSending.value = false;
      if (result != null) {
        messages.add(result);
        _selectedImage = null;
        final index = conversations.indexWhere((c) => c.id == selectedConversationId.value);
        if (index != -1) {
          final conv = conversations[index];
          final latestContent = result.content.isNotEmpty
              ? result.content
              : (result.imageUrl != null ? '📷 صورة' : '');
          final updatedConv = Conversation(
            id: conv.id,
            doctor: conv.doctor,
            patient: conv.patient,
            latestMessage: LatestMessage(
              id: result.id,
              conversationId: result.conversationId,
              content: latestContent,
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
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع: $e');
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        update();
      }
    } catch (e) {
      print('❌ Image pick error: $e');
      Get.snackbar('خطأ', 'فشل اختيار الصورة');
    }
  }

  void clearSelectedImage() {
    _selectedImage = null;
    update();
  }

  @override
  void onClose() {
    stopPolling(); 
    super.onClose();
  }
}