import 'package:compuvers/src/constants/colors.dart';
import 'package:compuvers/src/constants/image_strings.dart';
import 'package:compuvers/src/constants/sizes.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/authentication/controllers/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});

  final splashController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    splashController.startAnimation();
    return Scaffold(
      body: Stack(
        children: [
          Obx( () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1000),
              top: 100,
              left: splashController.animate.value ? cDefaultSize : -80,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: splashController.animate.value ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cAppName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      cAppTagline,
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,)
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx( () => Positioned(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 2000),
                opacity: splashController.animate.value  ? 1 : 0,
                child: const Center(
                  child: Image(
                    image: AssetImage(cSplashImage),
                    width: 450, 
                  ),
                ),
              ),
            ),
          ),
          Obx( () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1000),
              bottom: splashController.animate.value ? 90 : 0,
              right: cDefaultSize,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: splashController.animate.value  ? 1 : 0,
                child: Container(
                  width: cSplashContainerSize,
                  height: cSplashContainerSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: cPrimaryColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


}
