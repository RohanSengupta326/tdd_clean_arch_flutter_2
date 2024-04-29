part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final prefs = sl<SharedPreferences>();
      // SharedPreferences was already instantiated in dependency_injection
      // file, so don't have to reinstantiate it, so simply can call it.

      // creating different function cause else we will have to call
      // PageRouteBuilder everytime for a new page and have
      // to create custom animation for every page multiple times.
      return _pageBuilder(
        (context) {
          if (prefs.getBool(kFirstTimerKey) ?? true) {
            // we are wrapping with BlocProvider in here in the generatedRoute
// section for particular pages.
// but optimal way is to : imagine there are multiple blocProvider we
// need to use to wrap multiple pages. So we have to wrap each page
// individually with different BlocProviders.
// Rather, if we use MultiBlocProvider and wrap the materialApp we
// wrap all the pages with the necessary blocProviders.
            return BlocProvider(
              create: (_) => sl<OnBoardingCubit>(),
              child: const OnBoardingScreen(),
            );
          } else if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser!;

            // when user signsIn with click of a button,
            // it calls a chain of function till remoteDataSourceImpl and then
            // returns finally in UI a LocalUser entity, then we show the data
            // from that entity. But when a user is already signed in, we
            // are not receiving that entity anymore, so how can we show data.
            // so that's why we are taking the current user putting the data in
            // LocalUserModel , now we have access to the data of the user.

            // cause when user presses button and signs in, we use bloc to
            // take
            // data and then show rebuild UI and show data,
            // but when user is signedIn already, and app is restarted no data
            // is saved, then we have to take it from firebase and store locally
            // and show
            // it again, so for that we are using provider.

            // but also we are locally storing user data but not all the data is
            // being store properly like this here. like points : 0 ,and bio is
            // non existent ..so we have to actually properly fetch the data and
            // store locally in a model.
            // that we are doing after taking user to dashboard.
            // theres a dashboardController class.
            final localUser = LocalUserModel(
              uid: user.uid,
              email: user.email ?? '',
              points: 0,
              fullName: user.displayName ?? '',
            );

            context.userProvider.initUser(localUser);
            // using provider to save loaded userData, and to initUser data
            // when checked user first timer or not, then also updated userData
            // we change the userData
            // and all these functions we call from provider directly as we do.
            // and rebuild UI.
            // This is minor state management.
            // and mainly interlayer method calls, meaning mainly from
            // dataSourceImpl
            // class functions we use bloc to emit new states and receive data
            // and rebuild UI based on that.

            return const Dashboard();
          }
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const SignInScreen(),
          );
        },
        settings: settings,
      );
    case ss.SignInScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );
    case SignUpScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );
    case Dashboard.routeName:
      return _pageBuilder(
        (_) => const Dashboard(),
        settings: settings,
      );
    case '/forgot-password':
      return _pageBuilder(
        (_) => const fui.ForgotPasswordScreen(),
        // using firebase's own forgot password screen UI.
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
