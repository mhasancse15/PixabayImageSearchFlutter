import 'package:equatable/equatable.dart';

/// Base class for every recoverable error that can cross from the data
/// layer into the domain/presentation layers.
///
/// Using typed [Failure]s (instead of throwing raw exceptions across
/// layers) is what allows the repository contract to return
/// `Either<Failure, T>` and lets the UI branch on `failure.runtimeType`
/// without depending on Dio, sockets, or any data-layer detail.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Server responded but with an error status code / error payload.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred.']);
}

/// No network connectivity was available when the request was attempted.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// The request took too long and timed out.
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The request timed out.']);
}

/// Response payload could not be parsed into the expected model.
class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Failed to parse server response.']);
}

/// Fallback for anything unanticipated.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
