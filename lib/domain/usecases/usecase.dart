import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';

/// Standard shape for every use case: takes a single [Params] object
/// and returns `Either<Failure, Type>`.
///
/// Enforcing this interface keeps use cases interchangeable and easy
/// to unit test/mock from the controller layer.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Marker type for use cases that take no parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
