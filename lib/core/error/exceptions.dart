/// Exceptions thrown inside the data layer (remote data source).
///
/// These are caught by the repository implementation and translated
/// into [Failure]s so the rest of the app never has to know about
/// Dio, HTTP status codes, or JSON parsing internals.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred.']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);
}

class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'The request timed out.']);
}

class ParsingException implements Exception {
  final String message;
  const ParsingException([this.message = 'Failed to parse response.']);
}
