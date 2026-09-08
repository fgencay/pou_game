import 'package:flutter/material.dart';

void main() {
  runApp(const PouGameApp());
}

class PouGameApp extends StatelessWidget {
  const PouGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pou Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF67B26F)),
        useMaterial3: true,
      ),
      home: const StartupScreen(),
    );
  }
}

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pou Game', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 12),
            Text('Phase 0 ready', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
