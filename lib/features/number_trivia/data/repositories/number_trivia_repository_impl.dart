import 'package:clean_arch_app/core/error/exceptions.dart';
import 'package:clean_arch_app/features/number_trivia/data/models/number_trivia_model.dart';
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
  Future<Either<Failure, NumberTrivia>>? getConcreteNumberTrivia(
      int? number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    Future<NumberTriviaModel>? Function() getConcreteorRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteorRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia as NumberTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia as NumberTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
