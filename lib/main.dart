import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

@riverpod
Future<String> foo(FooRef ref) async {
  ref.onDispose(() {
    final x = 1;
  });

  ref.onCancel(() {
    final x = 1;
  });

  ref.onRemoveListener(() {
    final x = 1;
  });

  ref.onResume(() {
    final x = 1;
  });

  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();

  return String.fromCharCodes(Iterable.generate(
    10,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

void main() {
  // runApp(const MyApp());
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Bug Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: 'first',
      routes: {
        'first': (context) => const FirstScreen(),
        'second': (context) => const SecondScreen(),
      },
    );
  }
}

class FirstScreen extends ConsumerWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('second'),
              child: Text('Navigate to second screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends ConsumerWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ref.watch(fooProvider).when(
                  data: (data) => Text(
                    data,
                    textAlign: TextAlign.center,
                  ),
                  error: (_, __) => const Text('Error'),
                  loading: () => const Text('loading'),
                ),
            TextButton(
              onPressed: () => ref.invalidate(fooProvider),
              child: Text('Invalidate Provider'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Navigate back'),
            ),
          ],
        ),
      ),
    );
  }
}
