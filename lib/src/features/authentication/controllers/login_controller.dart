import 'package:compuvers/src/repository/authentication/authentication_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();

  /// TextField Validation

  Future<void> login() async {
    await AuthenticationRepository.instance.logInWithEmailAndPassword(email.text.trim(), password.text.trim());
  }
}