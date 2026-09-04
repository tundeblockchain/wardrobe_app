import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Canned HTTP response used by [ScriptedHttpAdapter].
class HttpScript {
  const HttpScript({
    required this.statusCode,
    this.body,
    this.headers = const {},
  });

  final int statusCode;
  final Object? body;
  final Map<String, List<String>> headers;

  ResponseBody toResponse() {
    if (body == null) {
      return ResponseBody.fromString(
        '',
        statusCode,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          ...headers,
        },
      );
    }
    final encoded = body is String ? body as String : jsonEncode(body);
    return ResponseBody.fromString(
      encoded,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        ...headers,
      },
    );
  }
}

/// Plays a sequence of scripted responses and records outbound requests.
class ScriptedHttpAdapter implements HttpClientAdapter {
  ScriptedHttpAdapter(this._scripts);

  final List<HttpScript> _scripts;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (_scripts.isEmpty) {
      throw StateError(
        'No scripted response for ${options.method} ${options.uri}',
      );
    }
    return _scripts.removeAt(0).toResponse();
  }

  @override
  void close({bool force = false}) {}
}
