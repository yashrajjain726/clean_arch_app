import 'dart:convert';

import 'package:clean_arch_app/core/error/exceptions.dart';
import 'package:clean_arch_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl? dataSourceImplementation;
  MockHttpClient? mockHttpClient;
  setUp(() {});
  mockHttpClient = MockHttpClient();
  dataSourceImplementation =
      NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);

  void setUpMockHttpClientSuccess200(url) {
    when(mockHttpClient!.get(Uri.parse(url), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(
              fixture('trivia.json'),
              200,
            ));
  }

  void setUpMockHttpClientFailure404(url) {
    when(mockHttpClient!.get(Uri.parse(url), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(
              'Something went Wrong',
              404,
            ));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final String url = 'http://numbersapi.com/$tNumber';
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on a URL with number 
        being the endpoint and with application/json header ''', () async {
      setUpMockHttpClientSuccess200(url);
      await dataSourceImplementation!.getConcreteNumberTrivia(tNumber);
      verify(mockHttpClient!.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      }));
    });
    test('should return numberTrivia if the response code is 200 [successfull]',
        () async {
      setUpMockHttpClientSuccess200(url);
      final result =
          await dataSourceImplementation!.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException if the response code is 400  or other',
        () async {
      setUpMockHttpClientFailure404(url);
      final result =
          await dataSourceImplementation!.getConcreteNumberTrivia(tNumber);
      expect(() => result, throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final String url = 'http://numbersapi.com/random';
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on a URL with number 
        being the endpoint and with application/json header ''', () async {
      setUpMockHttpClientSuccess200(url);
      await dataSourceImplementation!.getRandomNumberTrivia();
      verify(mockHttpClient!.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      }));
    });
    test('should return numberTrivia if the response code is 200 [successfull]',
        () async {
      setUpMockHttpClientSuccess200(url);
      final result = await dataSourceImplementation!.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException if the response code is 400  or other',
        () async {
      setUpMockHttpClientFailure404(url);
      final result = await dataSourceImplementation!.getRandomNumberTrivia();
      expect(() => result, throwsA(TypeMatcher<ServerException>()));
    });
  });
}
