import 'package:dartz/dartz.dart';

import 'package:clean_arch_app/core/platform/network_info.dart';
import 'package:clean_arch_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/numer_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImplementation implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  NumberTriviaRepositoryImplementation({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, NumberTrivia>>? getConcreteNumberTrivia(int? number) {
    return null;
  }

  @override
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia() {
    return null;
  }
}
