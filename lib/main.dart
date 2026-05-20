import 'package:flutter/material.dart';

void main() {
  runApp(const BusinessStackMarketplace());
}

class BusinessStackMarketplace extends StatelessWidget {
  const BusinessStackMarketplace({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BusinessStack Маркет',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.diamond, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            const Text('BusinessStack Маркет', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            const Text('Вход в разработке', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
