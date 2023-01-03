import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_arch_app/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImplementation networkInfoImplementation;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {});
  mockDataConnectionChecker = MockDataConnectionChecker();
  networkInfoImplementation = NetworkInfoImplementation(
      dataConnectionChecker: mockDataConnectionChecker);

  group('isConnected', () {
    test('should forward the call to dataconnectionchecker.hasConnection',
        () async {
      final tHasConnectionFuture = Future.value(true);
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);
      final result = networkInfoImplementation.isConnected;
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
