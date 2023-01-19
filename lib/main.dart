import 'package:clean_arch_app/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clean_arch_app/injection_container.dart' as dependencyInjection;
import 'package:flutter/material.dart';

Future<void> main() async {
  await dependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.green.shade600),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
