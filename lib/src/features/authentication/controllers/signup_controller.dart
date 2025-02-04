import 'package:compuvers/src/features/authentication/models/user_model.dart';
import 'package:compuvers/src/repository/authentication/authentication_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();

  // Fungsi untuk membuat user dan menyimpannya di Firestore & Firebase Authentication
  Future<void> createUser() async {
    try {
      // Ambil nilai email, password, dan fullName dari controller
      final emailVal = email.text.trim();
      final passwordVal = password.text.trim();
      final fullNameVal = fullName.text.trim();

      // Langkah pertama: Daftarkan pengguna di Firebase Authentication
      await AuthenticationRepository.instance.createUserWithEmailAndPassword(
        emailVal,
        passwordVal,
        fullNameVal, // Pass fullName to AuthenticationRepository
      );

    } catch (e) {
      // Tangani error sesuai dengan kebutuhan
      print("Error during sign up: $e");
      // Anda bisa menambahkan Get.snackbar atau dialog untuk memberi tahu pengguna
    }
  }
}
