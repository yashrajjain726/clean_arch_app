import 'package:bloc/bloc.dart';
import 'package:clean_arch_app/features/number_trivia/domain/entities/numer_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc() : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {});
  }
}
