import 'dart:convert';

import 'package:clean_arch_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch_app/features/number_trivia/domain/entities/numer_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final NumberTriviaModel tNumberTriviaModel =
      NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be a subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson ', () {
    test('valid model when the json number is an integer', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, equals(tNumberTriviaModel));
    });

    test('valid model when the json number is an double', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, equals(tNumberTriviaModel));
    });
  });
}
