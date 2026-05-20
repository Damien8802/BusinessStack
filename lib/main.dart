import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const BusinessStackMarketplace());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

class BusinessStackMarketplace extends StatelessWidget {
  const BusinessStackMarketplace({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BusinessStack Маркет',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFF59E0B),
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF2D2D44)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                  ),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.diamond, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              const Text('BusinessStack', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
              const Text('Маркетплейс', style: TextStyle(fontSize: 16, color: Color(0xFFFBBF24))),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final String _serverUrl = 'http://192.168.11.234:8080';

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните поля')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$_serverUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный email или пароль')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка подключения')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF2D2D44)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(child: Icon(Icons.diamond, size: 40, color: Colors.white)),
                  ),
                  const SizedBox(height: 30),
                  const Text('Добро пожаловать!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFFF59E0B), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFFF59E0B), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Войти'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Module {
  final String id;
  final String name;
  final String description;
  final String icon;
  final double price;
  final bool isAvailable;

  const Module({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.price,
    this.isAvailable = false,
  });

  Module copyWith({bool? isAvailable}) {
    return Module(
      id: id,
      name: name,
      description: description,
      icon: icon,
      price: price,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isOwner;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isOwner,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final email = json['email'] ?? '';
    final role = json['role'] ?? 'user';
    final isOwner = email == 'dev@businessstack.ru' || role == 'owner';
    
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? email.split('@')[0],
      email: email,
      role: role,
      isOwner: isOwner,
    );
  }
}

const List<Module> allModules = [
  Module(id: 'vpn', name: 'VPN', description: 'Обход блокировок', icon: '🔒', price: 0),
  Module(id: 'fincore', name: 'FinCore', description: 'Финансовый учет', icon: '💰', price: 999),
  Module(id: 'crm', name: 'CRM', description: 'Управление клиентами', icon: '🤝', price: 1499),
  Module(id: 'teamsphere', name: 'TeamSphere', description: 'Управление проектами', icon: '👥', price: 1299),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _currentUser;
  List<Module> _modules = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://192.168.11.234:8080/api/user/profile'),
          headers: {'Authorization': 'Bearer $token'},
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          _currentUser = User.fromJson(data);
          
          _modules = allModules.map((module) {
            final isAvailable = _currentUser!.isOwner || module.price == 0;
            return module.copyWith(isAvailable: isAvailable);
          }).toList();
        }
      } catch (e) {}
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF2D2D44)],
          ),
        ),
        child: Column(
          children: [
            if (_currentUser?.isOwner == true)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFFBBF24).withOpacity(0.2),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified, color: Color(0xFFFBBF24)),
                    SizedBox(width: 8),
                    Text('ВЛАДЕЛЕЦ ПЛАТФОРМЫ', style: TextStyle(color: Color(0xFFFBBF24))),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _modules.length,
                itemBuilder: (context, index) {
                  final module = _modules[index];
                  return Card(
                    color: module.isAvailable
                        ? const Color(0xFFF59E0B).withOpacity(0.1)
                        : Colors.white.withOpacity(0.05),
                    child: ListTile(
                      leading: Text(module.icon, style: const TextStyle(fontSize: 32)),
                      title: Text(module.name),
                      subtitle: Text(module.description),
                      trailing: module.isAvailable
                          ? const Icon(Icons.check_circle, color: Color(0xFFF59E0B))
                          : Chip(label: Text('${module.price} ₽'), backgroundColor: const Color(0xFFF59E0B)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
