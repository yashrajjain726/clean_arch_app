import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int? number);
  Future<NumberTriviaModel>? getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client httpClient;
  NumberTriviaRemoteDataSourceImpl({
    required this.httpClient,
  });
  @override
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int? number) async {
    return _getTriviaFromUrl('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel>? getRandomNumberTrivia() async {
    return _getTriviaFromUrl('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await httpClient.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
