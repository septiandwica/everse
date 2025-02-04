import 'package:compuvers/src/constants/image_strings.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:flutter/material.dart';

class SignupHeaderWidget extends StatelessWidget {
  const SignupHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage(cWelcome), height: size.height * 0.3,),
        Text(cLoginTitle, style: Theme.of(context).textTheme.headlineMedium,),
        Text(cLoginSub, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,),
      ],
    );
  }
}