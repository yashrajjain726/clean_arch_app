import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/features/number_trivia/domain/entities/numer_trivia.dart';
import 'package:clean_arch_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;
  GetConcreteNumberTrivia({
    required this.repository,
  });
  Future<Either<Failure, NumberTrivia>> execute({required int number}) async {
    print('indixe use case');
    return await repository.getConcreteNumberTrivia(number);
  }
}
