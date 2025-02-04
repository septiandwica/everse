
import 'package:compuvers/src/constants/sizes.dart';
import 'package:compuvers/src/features/authentication/models/on_boarding_models.dart';
import 'package:flutter/material.dart';

class OnBoardingPageWidget extends StatelessWidget {
  const OnBoardingPageWidget({
    super.key,
    required this.model,
  });

  final OnBoardingModels model;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(cDefaultSize),
      color: model.bgcolor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(image: AssetImage(model.image), height: size.height * 0.5,),
          Column(
            children: [
              Text(model.title, style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              )),
              Text(model.subTitle, style: Theme.of(context).textTheme.bodyLarge, textAlign:TextAlign.center),
            ],
          ),
          SizedBox(height: 50.0,)
        ],
      ),
    );
  }
}