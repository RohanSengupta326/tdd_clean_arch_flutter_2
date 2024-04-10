import 'package:clean_arch_bloc_2/core/utils/typdefs.dart';

// will identify user is first timer or old.
// based on that we will show the user getStarted pages or won't.

abstract class OnBoardingRepo {
  const OnBoardingRepo();

  ResultFuture<void> cacheFirstTimer();

  ResultFuture<bool> checkIfUserIsFirstTimer();
}
