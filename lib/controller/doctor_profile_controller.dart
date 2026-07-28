// lib/controller/doctor_profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/models/comment_model.dart';
import 'package:health_appointment_app/models/doctor_model.dart';
import 'package:health_appointment_app/models/post_model.dart';
import 'package:health_appointment_app/controller/posts_controller.dart';
import 'package:health_appointment_app/services/doctors_service.dart';
import 'package:health_appointment_app/services/posts_service.dart';

class DoctorProfileController extends GetxController {
  final DoctorsService _doctorsService = DoctorsService();
  final PostService _postService = PostService();

  // Posts controller for managing posts and comments
  final PostsController postsController = PostsController();

  // ---- Properties that forward to postsController ----
  List<CommentModel> get comments => postsController.comments;
  bool get isLoadingComments => postsController.isLoadingComments.value;
  String get commentsErrorMessage => postsController.commentsErrorMessage.value;
  int get selectedPostIdForComments => postsController.selectedPostIdForComments.value;
  set selectedPostIdForComments(int value) => postsController.selectedPostIdForComments.value = value;
  TextEditingController get commentController => postsController.commentController;
  bool get isAddingComment => postsController.isAddingComment.value;

  // ---- Methods that forward to postsController ----
  Future<void> fetchComments(int postId) => postsController.fetchComments(postId);
  Future<void> addCommentToPost(int postId, String content) => postsController.addCommentToPost(postId, content);
  String getTimeAgo(DateTime dateTime) => postsController.getTimeAgo(dateTime);

  // ---- Doctor profile specific ----
  var selectedTab = 0.obs;
  var selectedDayIndex = 0.obs;
  var selectedTimeIndex = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var doctor = Rxn<DoctorModel>();
  var doctorData = Rxn<Data>();

  var isFollowing = false.obs;
  var isFollowLoading = false.obs;

  var workingDaysList = <DaySchedule>[].obs;
  var dayNames = <String>[].obs;
  List<String> timeSlots = ['09:00 AM', '10:30 AM', '01:00 PM', '02:30 PM', '04:00 PM'];

  @override
  void onInit() {
    super.onInit();
    final int? doctorId = Get.arguments as int?;
    if (doctorId != null) {
      fetchDoctorDetails(doctorId);
    } else {
      errorMessage.value = 'No doctor ID provided';
    }
  }

  // ---- Fetch doctor details ----
  Future<void> fetchDoctorDetails(int id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _doctorsService.getDoctorById(id);
      if (result != null) {
        doctor.value = result;
        doctorData.value = result.data;
        _extractWorkingDays(result.data?.workingDaysHours);
        if (result.data != null) {
          await fetchDoctorPosts(result.data!.id!);
        }
      } else {
        errorMessage.value = 'Could not load doctor data';
      }
    } catch (e) {
      errorMessage.value = 'Error loading data';
    } finally {
      isLoading.value = false;
    }
  }

  // ---- Fetch doctor posts ----
  Future<void> fetchDoctorPosts(int doctorId, {String? search}) async {
    postsController.isLoading.value = true;
    postsController.errorMessage.value = '';
    try {
      final posts = await _doctorsService.getDoctorPosts(doctorId, search: search);
      postsController.isLoading.value = false;
      if (posts != null) {
        postsController.setPosts(posts);
      } else {
        postsController.errorMessage.value = 'Error loading posts';
      }
    } catch (e) {
      postsController.isLoading.value = false;
      postsController.errorMessage.value = 'Unexpected error';
    }
  }

  // ---- Extract working days ----
  void _extractWorkingDays(WorkingDaysHours? hours) {
    if (hours == null) return;
    final map = {
      'Monday': hours.monday,
      'Tuesday': hours.tuesday,
      'Wednesday': hours.wednesday,
      'Thursday': hours.thursday,
      'Friday': hours.friday,
      'Saturday': hours.saturday,
      'Sunday': hours.sunday,
    };
    dayNames.clear();
    workingDaysList.clear();
    map.forEach((name, schedule) {
      if (schedule != null && schedule.start != null && schedule.end != null) {
        dayNames.add(name);
        workingDaysList.add(schedule);
      }
    });
    if (dayNames.isEmpty) {
      dayNames.addAll(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']);
    }
  }

  // ---- Toggle follow ----
  Future<void> toggleFollow() async {
    if (doctorData.value == null) return;
    isFollowLoading.value = true;
    try {
      final result = await _doctorsService.toggleFollowDoctor(doctorData.value!.id!);
      if (result != null && result['status'] == 'success') {
        isFollowing.value = !isFollowing.value;
        Get.snackbar('Success', result['message'] ?? 'Follow updated');
      } else {
        Get.snackbar('Error', result?['message'] ?? 'Failed to update follow');
      }
    } catch (e) {
      Get.snackbar('Error', 'Unexpected error');
    } finally {
      isFollowLoading.value = false;
    }
  }

  // ---- Getters ----
  String getFullName() => doctorData.value?.user?.fullName ?? 'Doctor';
  String getSpecialtyName() => doctorData.value?.specialty?.name ?? 'Unknown specialty';
  String getRating() => doctorData.value?.ratingAverage ?? '0.0';
  String getConsultationFee() => doctorData.value?.consultationFee ?? '0';
  String getBio() => doctorData.value?.bio ?? 'No description';
  String getProfileImage() => doctorData.value?.user?.profilePictureUrl ?? '';
  String getEmail() => doctorData.value?.user?.email ?? 'Not available';
  String getPhone() => doctorData.value?.user?.phoneNumber ?? 'Not available';
  String getClinicLocation() => doctorData.value?.clinicLocation ?? 'Not specified';
  String getGender() {
    final g = doctorData.value?.user?.gender;
    if (g == 'M') return 'Male';
    if (g == 'F') return 'Female';
    return 'Not specified';
  }
  String getStatus() => doctorData.value?.status ?? 'Unknown';
  int getExperience() => doctorData.value?.yearsOfExperience ?? 0;

  // ---- Selectors ----
  void selectDay(int index) => selectedDayIndex.value = index;
  void selectTime(int index) => selectedTimeIndex.value = index;
  void selectTab(int index) => selectedTab.value = index;

  @override
  void onClose() {
    super.onClose();
  }
}