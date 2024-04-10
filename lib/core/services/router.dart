import 'package:clean_arch_bloc_2/core/common/views/page_under_construction.dart';
import 'package:clean_arch_bloc_2/src/on_boarding/presentation/views/on_boarding_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnBoardingScreen.routeName:
      // creating different function cause else we will have to call
      // PageRouteBuilder everytime for a new page and have
      // to create custom animation for every page multiple times.
      return _pageBuilder(
        (_) => const OnBoardingScreen(),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

// PageRouteBuilder gives us the option to create custom animation when
// switching pages.
PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
