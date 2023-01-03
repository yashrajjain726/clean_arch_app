import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImplementation implements NetworkInfo {
  DataConnectionChecker dataConnectionChecker;
  NetworkInfoImplementation({
    required this.dataConnectionChecker,
  });
  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
