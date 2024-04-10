import 'package:clean_arch_bloc_2/core/res/media_res.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(MediaRes.onBoardingBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            // Lotties are animations in json format
            // using external library : Lottie.
            child: Lottie.asset(
              MediaRes.pageUnderConstruction,
              // the lottie json files inside assets are downloaded from Adobe
              // After effects, the animation was created then was download as
              // json with some Adobe After Effects plugin.
            ),
          ),
        ),
      ),
    );
  }
}
