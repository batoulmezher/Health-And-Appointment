import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/posts_controller.dart';

class CommentsSection extends StatelessWidget {
  final PostsController controller;
  final Color commentBgColor;
  final Color textColor;
  final Color subTextColor;

  const CommentsSection({
    Key? key,
    required this.controller,
    required this.commentBgColor,
    required this.textColor,
    required this.subTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = GetStorage().read('token') ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: commentBgColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Obx(() {
        if (controller.isLoadingComments.value) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (controller.commentsErrorMessage.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              controller.commentsErrorMessage.value,
              style: TextStyle(color: Colors.red.shade400, fontSize: 13),
            ),
          );
        }
      
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.comments.length,
              itemBuilder: (context, index) {
                final comment = controller.comments[index];
                final patientName = comment.patient?.fullName ?? 'مريض';
                final timeAgo = controller.getTimeAgo(comment.createdAt);
                final imageUrl = comment.patient?.profilePictureUrl;

                Widget patientAvatar = CircleAvatar(
                  radius: 16,
                  backgroundColor: _getColorFromName(patientName),
                  child: Text(
                    patientName.isNotEmpty ? patientName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );

                if (imageUrl != null && imageUrl.isNotEmpty) {
                  patientAvatar = CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      imageUrl,
                      headers: token.isNotEmpty
                          ? {'Authorization': 'Bearer $token'}
                          : null,
                    ),
                    onBackgroundImageError: (_, __) {},
                  );
                }

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      patientAvatar,
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  patientName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  timeAgo,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              comment.content,
                              style: TextStyle(
                                fontSize: 13,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.commentController,
                      decoration: InputDecoration(
                        hintText: 'اكتب تعليقاً...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          final postId = controller.selectedPostIdForComments.value;
                          if (postId != 0) {
                            controller.addCommentToPost(postId, value);
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() {
                    return IconButton(
                      icon: Icon(
                        Icons.send,
                        color: controller.isAddingComment.value
                            ? Colors.grey
                            : appColor.appColor.primary,
                      ),
                      onPressed: controller.isAddingComment.value
                          ? null
                          : () {
                              final text = controller.commentController.text;
                              if (text.trim().isNotEmpty) {
                                final postId = controller.selectedPostIdForComments.value;
                                if (postId != 0) {
                                  controller.addCommentToPost(postId, text);
                                }
                              }
                            },
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Color _getColorFromName(String name) {
    final List<Color> colors = [
      const Color(0xFFE57373),
      const Color(0xFF81C784),
      const Color(0xFF64B5F6),
      const Color(0xFFFFD54F),
      const Color(0xFFFF8A65),
      const Color(0xFFA1887F),
      const Color(0xFF9575CD),
      const Color(0xFF4DB6AC),
      const Color(0xFFFF80AB),
      const Color(0xFF90A4AE),
    ];
    final int index = name.hashCode.abs() % colors.length;
    return colors[index];
  }
}