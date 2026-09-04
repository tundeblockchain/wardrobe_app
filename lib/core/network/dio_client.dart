import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import 'auth_interceptor.dart';
import 'firebase_id_token_source.dart';
import 'id_token_source.dart';

/// Source used by Dio to attach a Firebase ID token. Override in tests.
final idTokenSourceProvider = Provider<IdTokenSource>((ref) {
  if (Firebase.apps.isEmpty) {
    return const EmptyIdTokenSource();
  }
  return FirebaseIdTokenSource(FirebaseAuth.instance);
});

/// Builds a Dio client with the ID-token interceptor.
Dio createDioClient({
  required String baseUrl,
  required IdTokenSource tokenSource,
  Duration connectTimeout = const Duration(seconds: 15),
  Duration receiveTimeout = const Duration(seconds: 15),
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: const {Headers.acceptHeader: Headers.jsonContentType},
    ),
  );
  dio.interceptors.add(AuthInterceptor(tokenSource: tokenSource));
  return dio;
}

/// Configured Dio client. Tokens are attached per request, never persisted.
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final tokenSource = ref.watch(idTokenSourceProvider);
  return createDioClient(baseUrl: config.apiBaseUrl, tokenSource: tokenSource);
});

/// Dio used only for pre-signed S3 PUTs. No base URL and no auth interceptor —
/// extra signed headers would break the upload URL.
Dio createUploadDio({
  Duration connectTimeout = const Duration(seconds: 30),
  Duration sendTimeout = const Duration(seconds: 60),
  Duration receiveTimeout = const Duration(seconds: 30),
}) {
  return Dio(
    BaseOptions(
      connectTimeout: connectTimeout,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
    ),
  );
}

/// Bare upload client. Override in tests with a scripted adapter.
final uploadDioProvider = Provider<Dio>((ref) => createUploadDio());
