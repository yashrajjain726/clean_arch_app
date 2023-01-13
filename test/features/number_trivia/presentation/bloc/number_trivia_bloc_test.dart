import 'package:clean_arch_app/core/utils/input_converter.dart';
import 'package:clean_arch_app/features/number_trivia/domain/entities/numer_trivia.dart';
import 'package:clean_arch_app/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_arch_app/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:clean_arch_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc? numberTriviaBloc;
  MockGetConcreteNumberTrivia? mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia? mockGetRandomNumberTrivia;
  MockInputConverter? mockInputConverter;

  setUp(() {});

  test('initialState should be empty', () {
    expect(numberTriviaBloc!.state, equals(Empty()));
  });
  group('getTriviaForConctreteNumber', () {
    final tNumberString = "1";
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
        'shoudl call the input converter to validate and convert the string to an unsigned integer',
        () async {
      when(mockInputConverter!.stringToUnsignedInteger(tNumberString))
          .thenReturn(Right(tNumberParsed));
      numberTriviaBloc!
          .add(GetTriviaForConcreteEvent(numberString: tNumberString));
      await untilCalled(
          mockInputConverter.stringToUnsignedInteger(tNumberString));
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('shoud emit [Error] when the input is invalid', () async {
      when(mockInputConverter!.stringToUnsignedInteger(tNumberString))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [Error(errorMsg: INVALID_INPUT_FAILURE_MSG)];
      expectLater(numberTriviaBloc!.state, emitsInOrder(expected));
      numberTriviaBloc
          .add(GetTriviaForConcreteEvent(numberString: tNumberString));
    });
  });
}
