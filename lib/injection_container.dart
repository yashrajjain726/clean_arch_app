import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

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
    () =>
        NetworkInfoImplementation(internetConnectionChecker: serviceLocator()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );
  serviceLocator.registerLazySingleton(
    () => InternetConnectionChecker(),
  );
  serviceLocator.registerLazySingleton(
    () => HttpClient(),
  );
}
