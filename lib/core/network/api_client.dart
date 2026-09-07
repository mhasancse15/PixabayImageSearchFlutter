import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';
import '../error/exceptions.dart';

/// Thin wrapper around [Dio] that centralises base configuration,
/// logging and low-level error translation.
///
/// Data sources depend on this instead of raw [Dio] so that swapping
/// the HTTP client later (e.g. to `http` or a mock) only touches one
/// class.
class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: false,
        error: true,
        compact: true,
      ),
    );
  }

  /// Performs a GET request and returns the raw response data.
  ///
  /// Throws typed exceptions (see [exceptions.dart]) instead of
  /// [DioException] so upper layers never import Dio.
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final serverMessage =
            (e.response?.data is Map && e.response?.data['error'] != null)
                ? e.response!.data['error'].toString()
                : 'Server error (${status ?? 'unknown'}).';
        return ServerException(serverMessage);
      case DioExceptionType.cancel:
        return const ServerException('Request was cancelled.');
      default:
        return const ServerException();
    }
  }
}
