import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/authentication/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final RxBool isPasswordHidden = true.obs;

    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: cEmail,
                hintText: cEmail,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            Obx(() => TextFormField(
              controller: controller.password,
              obscureText: isPasswordHidden.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                labelText: cPwd,
                hintText: cPwd,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    isPasswordHidden.value = !isPasswordHidden.value;
                  },
                  icon: Icon(
                    isPasswordHidden.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            )),
            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(cForgotPwd),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.login(),
                child: Text(cLogin.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
