import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';

void main() {
  group('parseErrorEnvelope', () {
    test('maps flat {code, message} ticket envelope', () {
      final parsed = parseErrorEnvelope({
        'code': 'VALIDATION_ERROR',
        'message': 'name is required.',
      });

      expect(parsed?.code, 'VALIDATION_ERROR');
      expect(parsed?.message, 'name is required.');
    });

    test('maps nested backend {error: {code, message}} envelope', () {
      final parsed = parseErrorEnvelope({
        'error': {
          'code': 'WARDROBE_NOT_FOUND',
          'message': 'Wardrobe not found.',
        },
      });

      expect(parsed?.code, 'WARDROBE_NOT_FOUND');
      expect(parsed?.message, 'Wardrobe not found.');
    });

    test('returns null for unrelated payloads', () {
      expect(
        parseErrorEnvelope({'wardrobeId': 'wd_1', 'name': 'Home'}),
        isNull,
      );
      expect(parseErrorEnvelope('plain text'), isNull);
    });
  });

  group('ApiException.fromDio', () {
    test('prefers the shared error envelope', () {
      final exception = ApiException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/wardrobes'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/wardrobes'),
            statusCode: 400,
            data: const {
              'code': 'VALIDATION_ERROR',
              'message': 'name is required.',
            },
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(exception.code, 'VALIDATION_ERROR');
      expect(exception.message, 'name is required.');
      expect(exception.statusCode, 400);
    });

    test('maps connection errors', () {
      final exception = ApiException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/wardrobes'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(exception.code, 'NETWORK_ERROR');
      expect(exception.message, contains('connection'));
    });
  });
}
