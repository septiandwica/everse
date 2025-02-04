import 'package:compuvers/src/constants/sizes.dart';
import 'package:compuvers/src/features/authentication/screen/login_screen/login_footer_widget.dart';
import 'package:compuvers/src/features/authentication/screen/login_screen/login_form.dart';
import 'package:compuvers/src/features/authentication/screen/login_screen/login_header_widget.dart';
import 'package:compuvers/src/features/authentication/screen/signup_screen/signup_footer_widget.dart';
import 'package:compuvers/src/features/authentication/screen/signup_screen/signup_form.dart';
import 'package:compuvers/src/features/authentication/screen/signup_screen/signup_header_widget.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(cDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignupHeaderWidget(size: size),
              const SignupForm(),
              const SignupFooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
