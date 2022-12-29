import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/usecase.dart';
import '../entities/numer_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia({
    required this.repository,
  });
  @override
  Future<Either<Failure, NumberTrivia>?> call(NoParams noParams) async {
    return await repository.getRandomNumberTrivia();
  }
}
