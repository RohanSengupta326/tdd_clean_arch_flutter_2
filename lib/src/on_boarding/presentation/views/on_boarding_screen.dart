import 'package:clean_arch_bloc_2/core/common/views/loading_view.dart';
import 'package:clean_arch_bloc_2/core/common/widgets/gradient_background.dart';
import 'package:clean_arch_bloc_2/core/res/colours.dart';
import 'package:clean_arch_bloc_2/core/res/media_res.dart';
import 'package:clean_arch_bloc_2/src/on_boarding/domain/entities/page_content.dart';
import 'package:clean_arch_bloc_2/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:clean_arch_bloc_2/src/on_boarding/presentation/widgets/on_boarding_body.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GradientBackground(
        image: MediaRes.onBoardingBackground,
        // Actually to check if user is cached then we have to check user is
        // logged in or not, then different screens according to that
        // so its better to built out authentication and other necessary
        // functionalities of before this. at least in this case we need it.
        // but for now its not done before hand.
        child: BlocConsumer<OnBoardingCubit, OnBoardingState>(
          listener: (context, state) {
            if (state is OnBoardingStatus && !state.isFirstTimer) {
              Navigator.pushReplacementNamed(context, '/home');
              //   actually this condition is already handled in route : '/'
              // so we could've just called Navigator.pushReplacementNamed(context, '/');
              // only without conditions.
              //   but in their we are checking using sharedPreferences that
              //   user is firstTimer or not.
              //   but if sharedPreferences fails the condition will be checked
              //   here in these if else statements.

              //
            } else if (state is UserCached) {
              Navigator.pushReplacementNamed(context, '/');
            }
          },
          builder: (context, state) {
            if (state is CheckingIfUserIsFirstTimer ||
                state is CachingFirstTimer) {
              return const LoadingView();
            }
            return Stack(
              children: [
                // PageView() is used for showing pages like : GetStarted where
                // users have to slide through pages and get started finally
                // by sliding the screen.
                PageView(
                  controller: pageController,
                  children: const [
                    OnBoardingBody(pageContent: PageContent.first()),
                    OnBoardingBody(pageContent: PageContent.second()),
                    OnBoardingBody(pageContent: PageContent.third()),
                  ],
                ),
                // below is the logic for the change dots to slide right
                // to a different getStarted page.
                Align(
                  alignment: const Alignment(0, .04),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    onDotClicked: (index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 40,
                      activeDotColor: Colours.primaryColour,
                      dotColor: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
