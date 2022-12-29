import 'package:clean_arch_app/core/use_cases/usecase.dart';
import 'package:clean_arch_app/features/number_trivia/domain/entities/numer_trivia.dart';
import 'package:clean_arch_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch_app/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_arch_app/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() async {
  GetRandomNumberTrivia? usecase;
  MockNumberTriviaRepository? mockRandomNumberTriviaRepo;

  setUp(() {
    mockRandomNumberTriviaRepo = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository: mockRandomNumberTriviaRepo!);
  });

  final tNumberTrivia = NumberTrivia(text: 'interesting test', number: 29);
  test('should get trivia for randomly generated number from the repository',
      () async {
    when(mockRandomNumberTriviaRepo!.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    final result = await usecase!(NoParams());
    expect(result, Right(tNumberTrivia));
    verify(mockRandomNumberTriviaRepo!.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockRandomNumberTriviaRepo);
  });
}
