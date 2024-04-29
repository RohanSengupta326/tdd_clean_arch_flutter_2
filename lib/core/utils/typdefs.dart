import 'package:clean_arch_bloc_2/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

// we handle exceptions like this, to maintain testability
// else we would have to take context as argument in the dataSource
// methods and then show snackBars there itself, which will ruin the
// testability cause how can you access the context there in that method.

// also we use Failures cause we can't return Exceptions
// we can only throw Exceptions.

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef DataMap = Map<String, dynamic>;
