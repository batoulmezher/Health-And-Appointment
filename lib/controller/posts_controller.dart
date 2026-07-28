// lib/controller/posts_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/models/comment_model.dart';
import 'package:health_appointment_app/models/post_model.dart';
import 'package:health_appointment_app/services/posts_service.dart';

class PostsController extends GetxController {
  final PostService _postService = PostService();

  var posts = <PostModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var comments = <CommentModel>[].obs;
  var isLoadingComments = false.obs;
  var isAddingComment = false.obs;
  var commentsErrorMessage = ''.obs;
  var selectedPostIdForComments = 0.obs;
  final TextEditingController commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts();
  }

  void setPosts(List<PostModel> newPosts) {
    posts.value = newPosts;
  }

  Future<void> fetchAllPosts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final postsList = await _postService.getAllPosts();
      isLoading.value = false;
      if (postsList != null) {
        posts.value = postsList; 
        if (postsList.isEmpty) {
          errorMessage.value = 'No posts available';
        }
      } else {
        errorMessage.value = 'Failed to load posts';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred';
    }
  }

  Future<void> fetchComments(int postId) async {
    selectedPostIdForComments.value = postId;
    isLoadingComments.value = true;
    commentsErrorMessage.value = '';
    try {
      final commentsList = await _postService.getComments(postId);
      isLoadingComments.value = false;
      if (commentsList != null) {
        comments.value = commentsList;
      } else {
        commentsErrorMessage.value = 'Error loading comments';
        comments.clear();
      }
    } catch (e) {
      isLoadingComments.value = false;
      commentsErrorMessage.value = 'An error occurred';
      comments.clear();
    }
  }

  Future<void> addCommentToPost(int postId, String content) async {
    if (content.trim().isEmpty) {
      Get.snackbar('Alert', 'Please enter a comment');
      return;
    }
    isAddingComment.value = true;
    final success = await _postService.addComment(postId, content);
    isAddingComment.value = false;
    if (success) {
      commentController.clear();
      Get.snackbar('Success', 'Comment added successfully');
      await fetchComments(postId);
    } else {
      Get.snackbar('Error', 'Failed to add comment');
    }
  }

  Future<void> toggleLikePost(int postId, int index) async {
    try {
      final result = await _postService.toggleLike(postId);
      if (result != null && result['status'] == 'success') {
        final currentPost = posts[index];
        final updatedPost = PostModel(
          id: currentPost.id,
          doctor: currentPost.doctor,
          content: currentPost.content,
          likesCount: currentPost.isLikedByCurrentUser 
              ? currentPost.likesCount - 1 
              : currentPost.likesCount + 1,
          commentsCount: currentPost.commentsCount,
          isLikedByCurrentUser: !currentPost.isLikedByCurrentUser,
          createdAt: currentPost.createdAt,
          imageUrl: currentPost.imageUrl,
        );
        posts[index] = updatedPost;
        posts.refresh();
      } else {
        Get.snackbar('Error', result?['message'] ?? 'Failed to update like');
      }
    } catch (e) {
      Get.snackbar('Error', 'Unexpected error');
    }
  }

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute ago';
    } else {
      return 'Just now';
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}