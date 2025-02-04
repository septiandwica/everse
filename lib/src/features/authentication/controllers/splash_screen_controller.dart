import 'package:compuvers/src/features/authentication/screen/on_boarding/on_boarding_screen.dart';
// import 'package:compuvers/src/features/authentication/screen/welcome/welcome_screen.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController{
  static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

    Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 3000));
    Get.to(OnBoardingScreen());
  }
}