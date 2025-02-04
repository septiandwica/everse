import 'package:compuvers/src/constants/image_strings.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/authentication/screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignupFooterWidget extends StatelessWidget {
  const SignupFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        TextButton(
          onPressed: () => Get.to(()=>LoginScreen()),
          child:  Text.rich(
            TextSpan(
              text: cAlreadyHaveAnAccount,
              style: Theme.of(context).textTheme.bodyMedium,
              children: const [
                TextSpan(
                  text: cLogin,
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

