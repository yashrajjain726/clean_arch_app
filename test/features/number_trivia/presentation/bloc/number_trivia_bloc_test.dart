import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/core/use_cases/usecase.dart';
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
    final tNumberTrivia = const NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter!.stringToUnsignedInteger(tNumberString))
            .thenReturn(Right(tNumberParsed));
    void setUpMockInputConverterFailure() =>
        when(mockInputConverter!.stringToUnsignedInteger(tNumberString))
            .thenReturn(Left(InvalidInputFailure()));
    test(
        'shoudl call the input converter to validate and convert the string to an unsigned integer',
        () async {
      setUpMockInputConverterSuccess();
      numberTriviaBloc!
          .add(GetTriviaForConcreteEvent(numberString: tNumberString));
      await untilCalled(
          mockInputConverter!.stringToUnsignedInteger(tNumberString));
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('shoud emit [Error] when the input is invalid', () async {
      setUpMockInputConverterFailure();

      final expected = [
        Empty(),
        Error(errorMsg: INVALID_INPUT_FAILURE_MSG),
      ];
      expectLater(numberTriviaBloc!.state, emitsInOrder(expected));
      numberTriviaBloc
          .add(GetTriviaForConcreteEvent(numberString: tNumberString));
    });
    test('shoud get data from the concrete usecase', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia!(Params(number: tNumberParsed)))
          .thenAnswer((_) async => Right(tNumberTrivia));
      numberTriviaBloc!
          .add(GetTriviaForConcreteEvent(numberString: tNumberString));

      await untilCalled(
          mockGetConcreteNumberTrivia!(Params(number: tNumberParsed)));

      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('shoud emit[Loading,Loaded] when data is gotten successfully',
        () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia!(Params(number: tNumberParsed)))
          .thenAnswer((_) async => Right(tNumberTrivia));
      final expected = [
        Empty(),
        Loading(),
        Loaded(numberTrivia: tNumberTrivia),
      ];
      expectLater(numberTriviaBloc!.state, emitsInOrder(expected));
      numberTriviaBloc
          .add(GetTriviaForConcreteEvent(numberString: tNumberString));
    });

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia!(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(ServerFailure()));
        final expected = [
          Empty(),
          Loading(),
          Error(errorMsg: SERVER_FAILURE_MSG),
        ];
        expectLater(numberTriviaBloc!.state, emitsInOrder(expected));
        numberTriviaBloc
            .add(GetTriviaForConcreteEvent(numberString: tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia!(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(CacheFailure()));
        final expected = [
          Empty(),
          Loading(),
          Error(errorMsg: CACHE_FAILURE_MSG),
        ];
        expectLater(numberTriviaBloc!.state, emitsInOrder(expected));

        numberTriviaBloc
            .add(GetTriviaForConcreteEvent(numberString: tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random use case',
      () async {
        when(mockGetRandomNumberTrivia!(const NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        numberTriviaBloc!.add(GetTriviaForRandomEvent());
        await untilCalled(mockGetRandomNumberTrivia(const NoParams()));
        verify(mockGetRandomNumberTrivia(const NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        when(mockGetRandomNumberTrivia!(const NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        final expected = [
          Empty(),
          Loading(),
          Loaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(numberTriviaBloc!.state, emitsInOrder(expected));
        numberTriviaBloc.add(GetTriviaForRandomEvent());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        when(mockGetRandomNumberTrivia!(const NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
        final expected = [
          Empty(),
          Loading(),
          Error(errorMsg: SERVER_FAILURE_MSG),
        ];
        expectLater(numberTriviaBloc!.state, emitsInOrder(expected));
        numberTriviaBloc.add(GetTriviaForRandomEvent());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        when(mockGetRandomNumberTrivia!(const NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));
        final expected = [
          Empty(),
          Loading(),
          Error(errorMsg: CACHE_FAILURE_MSG),
        ];
        expectLater(numberTriviaBloc!.state, emitsInOrder(expected));
        numberTriviaBloc.add(GetTriviaForRandomEvent());
      },
    );
  });
}
