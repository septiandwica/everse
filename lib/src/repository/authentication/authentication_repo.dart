import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compuvers/src/features/authentication/models/user_model.dart';
import 'package:compuvers/src/features/dashboard/screen/dashboard.dart';
import 'package:compuvers/src/features/authentication/screen/welcome/welcome_screen.dart';
import 'package:compuvers/src/repository/authentication/exception/login_exception.dart';
import 'package:compuvers/src/repository/authentication/exception/signup_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => const WelcomeScreen()) : Get.offAll(() => const UserDashboard());
  }

  // Validasi email sebelum membuat akun
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.)?president\.ac\.id$");

    // Check if the email matches the valid domain regex
    if (emailRegex.hasMatch(email)) {
      return true;
    }

    // Add the exception for septiandwica@gmail.com
    if (email == 'septiandwica@gmail.com') {
      return true;
    }

    // Otherwise, return false for invalid email
    return false;
  }


  // Fungsi untuk membuat pengguna baru
  Future<void> createUserWithEmailAndPassword(String email, String password, String fullName) async {
    try {
      // Validasi domain email
      if (!isValidEmail(email)) {
        throw SignUpWithEmailAndPasswordFailure.code('invalid-domain');
      }

      // Membuat user baru di Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;

      if (user != null) {
        // Menambahkan data pengguna ke Firestore
        UserModel newUser = UserModel(
          id: user.uid,
          fullName: fullName,
          email: email,
          password: password,
          createdAt: Timestamp.now(),
        );

        // Simpan data pengguna di Firestore dengan ID sesuai dengan UID Firebase Authentication
        await _firestore.collection("Users").doc(user.uid).set(newUser.toJson()).then((_) {
          Get.snackbar(
            "Success",
            "Your Account Has been Created",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          );
          // Redirect ke dashboard setelah sukses
          Get.offAll(() => const UserDashboard());
        }).catchError((error) {
          Get.snackbar(
            "Error",
            "Something went wrong. Try Again",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red,
          );
          print("ERROR - $error");
        });
      } else {
        throw const SignUpWithEmailAndPasswordFailure();
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('Exception: - ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      print('Exception: - ${ex.message}');
      throw ex;
    }
  }


  Future<void> logInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = LogInWithEmailAndPasswordFailure.code(e.code);
      print('Exception: - ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = LogInWithEmailAndPasswordFailure();
      print('Exception: - ${ex.message}');
      throw ex;
    }
  }

  Future<void> logout() async => await _auth.signOut();

  // Fungsi untuk mendapatkan detail pengguna berdasarkan email
  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _firestore.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  // Fungsi untuk memperbarui data pengguna, termasuk password
  Future<void> updateUserRecord(UserModel user, String newPassword) async {
    try {
      // 1. Update password di Firebase Authentication
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Updating the password in Firebase Authentication
        await currentUser.updatePassword(newPassword);

        // Optionally reauthenticate user (important for some actions like password change)
        await currentUser.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: currentUser.email!,
            password: user.password, // Current password
          ),
        );

        print("Password updated successfully in Firebase Authentication");

        // 2. Update Firestore user record (if needed, though not recommended to store passwords here)
        await _firestore.collection("Users").doc(user.id).update({
          'password': newPassword, // This should be avoided for security reasons
        });

        print("User profile updated successfully in Firestore");

        // Show success snackbar
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            "Success",
            "Profile Updated",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            borderRadius: 10.0,
            margin: const EdgeInsets.all(16.0),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            snackStyle: SnackStyle.FLOATING,
          );
        });
      } else {
        throw Exception("No user is currently logged in.");
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar(
        "Error",
        "Something went wrong. Try Again",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
}
