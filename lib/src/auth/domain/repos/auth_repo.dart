import 'package:clean_arch_bloc_2/core/enums/update_user.dart';
import 'package:clean_arch_bloc_2/core/utils/typdefs.dart';
import 'package:clean_arch_bloc_2/src/auth/domain/entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<void> forgotPassword(String email);

  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });

  ResultFuture<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}
