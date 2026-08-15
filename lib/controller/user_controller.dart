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

  String get userEmail => currentUser.value?.email ?? 'example@gmail.com';
  int get userId => currentUser.value?.id ?? 0;

  void setUser(User user) {
    currentUser.value = user;
    _storage.write('user_id', user.id);
    _storage.write('user_full_name', user.fullName);
    _storage.write('user_email', user.email);
    if (user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty) {
      _storage.write('user_profile_picture', user.profilePictureUrl);
    } else {
      _storage.remove('user_profile_picture');
    }
    print("✅ User saved: ${user.fullName}, Image: ${user.profilePictureUrl}");
  }

  void loadUserFromStorage() {
    final id = _storage.read('user_id') as int?;
    final name = _storage.read('user_full_name') as String?;
    final email = _storage.read('user_email') as String?;
    final image = _storage.read('user_profile_picture') as String?;
    if (name != null) {
      currentUser.value = User(
        id: id,
        fullName: name,
        email: email ?? '',
        profilePictureUrl: image,
      );
      print("✅ User loaded from storage: $name, Image: $image");
    }
  }

  void logout() {
    currentUser.value = null;
    _storage.remove('user_id');
    _storage.remove('user_full_name');
    _storage.remove('user_email');
    _storage.remove('user_profile_picture');
    _storage.remove('token');
    Get.offAllNamed('/login');
  }
 
  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
  }
}