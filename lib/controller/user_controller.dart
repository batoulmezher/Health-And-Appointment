// lib/controller/user_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/models/doctor_model.dart';

class UserController extends GetxController {
  final GetStorage _storage = GetStorage();
  var currentUser = Rxn<User>();

  String get userName => currentUser.value?.fullName ?? 'مستخدم';
  
  String get userImage {
    final image = currentUser.value?.profilePictureUrl;
    if (image != null && image.isNotEmpty) {
      return '$image?t=${DateTime.now().millisecondsSinceEpoch}';
    }
    return '';
  }

  void setUser(User user) {
    currentUser.value = user;
    _storage.write('user_full_name', user.fullName);
    if (user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty) {
      _storage.write('user_profile_picture', user.profilePictureUrl);
    } else {
      _storage.remove('user_profile_picture');
    }
    print("✅ User saved: ${user.fullName}, Image: ${user.profilePictureUrl}");
  }

  void loadUserFromStorage() {
    final name = _storage.read('user_full_name') as String?;
    final image = _storage.read('user_profile_picture') as String?;
    if (name != null) {
      currentUser.value = User(
        fullName: name,
        profilePictureUrl: image,
      );
      print("✅ User loaded from storage: $name, Image: $image");
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
  }
}