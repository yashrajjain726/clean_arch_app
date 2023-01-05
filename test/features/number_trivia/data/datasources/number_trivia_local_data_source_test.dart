import 'dart:convert';

import 'package:clean_arch_app/core/error/exceptions.dart';
import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourceImplementation localDataSourceImplementation;
  setUp(() {});
  mockSharedPreferences = MockSharedPreferences();
  localDataSourceImplementation = NumberTriviaLocalDataSourceImplementation(
      sharedPreference: mockSharedPreferences);

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return NumberTriviaModel from sharedpreferences, when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(''))
          .thenReturn(fixture('trivia_cached.json'));
      final result = await localDataSourceImplementation.getLastNumberTrivia();
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return CacheException when there is no data in the cache',
        () async {
      when(mockSharedPreferences.getString('')).thenReturn(null);
      final call = localDataSourceImplementation.getLastNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Trivia', number: 1);
    test('should call sharedpreference to cache the data', () async {
      localDataSourceImplementation.cacheNumberTrivia(tNumberTriviaModel);
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
