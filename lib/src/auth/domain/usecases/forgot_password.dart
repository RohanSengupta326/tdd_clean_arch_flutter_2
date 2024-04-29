import 'package:clean_arch_bloc_2/core/usecases/usecases.dart';
import 'package:clean_arch_bloc_2/core/utils/typdefs.dart';
import 'package:clean_arch_bloc_2/src/auth/domain/repos/auth_repo.dart';

class ForgotPassword extends UsecaseWithParams<void, String> {
  const ForgotPassword(this._repo);

  final AuthRepo _repo; // this is causing the loose coupling : the injection.

  @override
  ResultFuture<void> call(String params) => _repo.forgotPassword(params);
}
