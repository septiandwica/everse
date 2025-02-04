import 'package:compuvers/src/constants/colors.dart';
import 'package:compuvers/src/constants/image_strings.dart';
import 'package:compuvers/src/constants/sizes.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/authentication/screen/login_screen/login_screen.dart';
import 'package:compuvers/src/features/authentication/screen/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;


    return Scaffold(
      backgroundColor: isDarkMode ? cDarkModeColor : cLightModeColor,
      body: Container(
        padding: EdgeInsets.all(cDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage(cWelcome), height: height *0.4,),
            Column(
              children: [
                Text(cWelcomeTitle, style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ), textAlign: TextAlign.center,),
                Text(cWelcomeSub, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () => Get.to(()=>LoginScreen()),
                      child: Text(cLogin.toUpperCase())
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () => Get.to(() => SignupScreen()),

                      child: Text(cSignUp.toUpperCase())
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}