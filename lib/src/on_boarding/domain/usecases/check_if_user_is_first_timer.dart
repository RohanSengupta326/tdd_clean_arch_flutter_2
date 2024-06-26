import 'package:clean_arch_bloc_2/core/usecases/usecases.dart';
import 'package:clean_arch_bloc_2/core/utils/typdefs.dart';
import 'package:clean_arch_bloc_2/src/on_boarding/domain/repos/on_boarding_repo.dart';

class CheckIfUserIsFirstTimer extends UsecaseWithoutParams<bool> {
  const CheckIfUserIsFirstTimer(this._repo);

  final OnBoardingRepo _repo;

  @override
  ResultFuture<bool> call() => _repo.checkIfUserIsFirstTimer();
}
