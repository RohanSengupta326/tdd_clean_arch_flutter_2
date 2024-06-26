import 'package:clean_arch_bloc_2/core/usecases/usecases.dart';
import 'package:clean_arch_bloc_2/core/utils/typdefs.dart';
import 'package:clean_arch_bloc_2/src/auth/domain/entities/user.dart';
import 'package:clean_arch_bloc_2/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class SignIn extends UsecaseWithParams<LocalUser, SignInParams> {
  const SignIn(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<LocalUser> call(SignInParams params) => _repo.signIn(
        email: params.email,
        password: params.password,
      );
}


//  we make different classes to take parameters in the method of the
// usecases because assume if multiple parameters are there
// then we will have to create a list of unlimited params.
// which is not optimal , rather than we are creating a compact package of
// params in a different class, like we create a model/entity.
class SignInParams extends Equatable {
  const SignInParams({
    required this.email,
    required this.password,
  });

  const SignInParams.empty()
      : email = '',
        password = '';

  final String email;
  final String password;

  @override
  List<String> get props => [email, password];
}
