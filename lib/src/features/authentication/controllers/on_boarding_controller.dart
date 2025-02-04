import 'package:compuvers/src/constants/colors.dart';
import 'package:compuvers/src/constants/image_strings.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/authentication/models/on_boarding_models.dart';
import 'package:compuvers/src/features/authentication/screen/on_boarding/on_boarding_page_widget.dart';
import 'package:compuvers/src/features/authentication/screen/welcome/welcome_screen.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnBoardingController extends GetxController{

  final controller = LiquidController();
  RxInt currentPage = 0.obs;


  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModels(
        image: cOnBoardingone, 
        title: cOnBoardingTitle1, 
        subTitle: cOnBoardingSub1, 
        bgcolor: cOnBoardingPage1Color, 
        // height: size.height,
      )
    ),
    OnBoardingPageWidget(
      model: OnBoardingModels(
        image: cOnBoardingtwo, 
        title: cOnBoardingTitle2, 
        subTitle: cOnBoardingSub2, 
        bgcolor: cOnBoardingPage2Color, 
        // height: size.height,
      )
    ),
    OnBoardingPageWidget(
      model: OnBoardingModels(
        image: cOnBoardingthree, 
        title: cOnBoardingTitle3, 
        subTitle: cOnBoardingSub3, 
        bgcolor: cOnBoardingPage3Color, 
        // height: size.height,
      )
    )
  ];

  onPageChangedCallback(int activePageIndex) => currentPage.value = activePageIndex; 
  skip() {
    Get.to(() => const WelcomeScreen());
  }
}