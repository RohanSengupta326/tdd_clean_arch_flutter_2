import 'package:clean_arch_bloc_2/core/errors/failures.dart';
import 'package:clean_arch_bloc_2/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:clean_arch_bloc_2/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CacheFirstTimer usecase;

  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CacheFirstTimer(repo);
  });

  final tServerFailure = ServerFailure(
    message: 'Unknown Error Occurred',
    statusCode: 500,
  );

  test(
    'should call the [OnBoardingRepo.cacheFirstTimer] '
    'and return the right data',
    () async {
      when(() => repo.cacheFirstTimer()).thenAnswer(
        // we are checking here the method is getting called and returning
        // expected type or not, either Right(null) or Left(Failure()). so
        // we can either expect Right(null) or Left(FailureType()).

        (_) async => Left(tServerFailure),
      );

      final result = await usecase();

      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            tServerFailure,
          ),
        ),
      );
      verify(() => repo.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
