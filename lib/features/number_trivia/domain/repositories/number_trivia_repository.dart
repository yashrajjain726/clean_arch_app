import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/numer_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
