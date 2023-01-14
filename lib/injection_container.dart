import 'dart:io';

import 'package:clean_arch_app/core/network/network_info.dart';
import 'package:clean_arch_app/core/utils/input_converter.dart';
import 'package:clean_arch_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arch_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch_app/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_arch_app/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:clean_arch_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;
Future<void> init() async {
  //! Features - Number Trivia

  // Bloc
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: serviceLocator(),
      getRandomNumberTrivia: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );
  // Use Cases
  serviceLocator.registerLazySingleton(
    () => GetConcreteNumberTrivia(
      repository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetRandomNumberTrivia(
      repository: serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImplementation(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );
  // Data Sources
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImplementation(
      sharedPreference: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      httpClient: serviceLocator(),
    ),
  );

  //! Core
  serviceLocator.registerLazySingleton(
    () => InputConverter(),
  );
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImplementation(dataConnectionChecker: serviceLocator()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );
  serviceLocator.registerLazySingleton(
    () => DataConnectionChecker(),
  );
  serviceLocator.registerLazySingleton(
    () => HttpClient(),
  );
}
