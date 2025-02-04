import 'package:compuvers/src/features/authentication/models/user_model.dart';
import 'package:compuvers/src/repository/authentication/authentication_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());

  // Get the current user's data
  Future<UserModel?> getUserData() async {
    final currentUser = _authRepo.firebaseUser.value;
    if (currentUser != null) {
      return await _authRepo.getUserDetails(currentUser.email!);
    } else {
      Get.snackbar("Error", "Login to Continue");
      return null;
    }
  }

  // Update user profile including password
  Future<void> updateRecord(UserModel user, String newPassword) async {
    await _authRepo.updateUserRecord(user, newPassword);
  }
}
