import 'dart:convert';

import 'package:clean_arch_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel>? getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel? triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImplementation
    implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreference;

  NumberTriviaLocalDataSourceImplementation({required this.sharedPreference});
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel? triviaToCache) async {
    sharedPreference.setString(
        CACHED_NUMBER_TRIVIA, json.encode(triviaToCache!.toJson()));
  }

  @override
  Future<NumberTriviaModel>? getLastNumberTrivia() {
    final jsonString = sharedPreference.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}