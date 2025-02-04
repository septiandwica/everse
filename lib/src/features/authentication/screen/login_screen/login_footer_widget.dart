import 'package:compuvers/src/constants/image_strings.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/authentication/screen/login_screen/login_screen.dart';
import 'package:compuvers/src/features/authentication/screen/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        TextButton(
          onPressed: () => Get.to(()=> const SignupScreen()),
          child:  Text.rich(
            TextSpan(
              text: cDontHaveAnAccount,
              style: Theme.of(context).textTheme.bodyMedium,
              children: const [
                TextSpan(
                  text: cSignUp,
                  style: TextStyle(color: Colors.blue),
                )
              ],
            )
          ),
        )
      ],
    );
  }
}

