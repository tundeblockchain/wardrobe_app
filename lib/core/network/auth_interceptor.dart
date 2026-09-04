import 'package:dio/dio.dart';

import 'id_token_source.dart';

/// Attaches `Authorization: Bearer <idToken>` when a Firebase user is signed in.
///
/// The token is fetched from [IdTokenSource] on every request and is never
/// stored on this interceptor or in app state.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this._tokenSource});

  final IdTokenSource _tokenSource;

  static const authorizationHeader = 'Authorization';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Future<void>(() async {
      final token = await _tokenSource.getIdToken();
      if (token != null && token.isNotEmpty) {
        options.headers[authorizationHeader] = 'Bearer $token';
      }
      handler.next(options);
    }).catchError((Object error, StackTrace stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    });
  }
}
