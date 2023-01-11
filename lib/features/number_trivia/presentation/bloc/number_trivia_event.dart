part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteEvent extends NumberTriviaEvent {
  final String numberString;
  const GetTriviaForConcreteEvent({
    required this.numberString,
  });
  @override
  List<Object> get props => [numberString];
}

class GetTriviaForRandomEvent extends NumberTriviaEvent {}
