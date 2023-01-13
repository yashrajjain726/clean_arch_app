import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:clean_arch_app/core/utils/input_converter.dart';
import 'package:clean_arch_app/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_arch_app/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

import '../../domain/entities/numer_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MSG = 'Server Failure';
const String CACHE_FAILURE_MSG = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MSG =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia? getConcreteNumberTrivia;
  final GetRandomNumberTrivia? getRandomNumberTrivia;
  final InputConverter? inputConverter;
  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    // ignore: void_checks
    on<GetTriviaForConcreteEvent>((event, emit) async* {
      final inputEither =
          inputConverter!.stringToUnsignedInteger(event.numberString);
      yield* inputEither.fold((failure) async* {
        yield Error(errorMsg: INVALID_INPUT_FAILURE_MSG);
      }, (integer) => throw UnimplementedError());
    });
  }
}
