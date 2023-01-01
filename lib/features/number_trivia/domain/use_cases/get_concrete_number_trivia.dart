import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/usecase.dart';
import '../entities/numer_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;
  GetConcreteNumberTrivia({
    required this.repository,
  });
  @override
  Future<Either<Failure, NumberTrivia>?> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}
