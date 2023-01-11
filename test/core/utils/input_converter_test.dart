import 'package:clean_arch_app/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {});
  inputConverter = InputConverter();

  group('string to unsigned int', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      const str = '123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, const Right(123));
    });

    test('should return an failure when the string not an integer', () async {
      const str = 'abc';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return an failure when the string is a negative integer',
        () async {
      const str = '-123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
