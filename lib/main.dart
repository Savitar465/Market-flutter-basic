import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market/models/product.dart';
import 'package:market/screens/home_screen.dart';
import 'package:market/services/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Isar and add some dummy data
  final isarService = IsarService();
  final isar = await isarService.db;
  if ((await isar.products.count()) == 0) {
    isarService.addProduct(Product(name: 'Laptop', price: 1200.00, stock: 10));
    isarService.addProduct(Product(name: 'Mouse', price: 25.00, stock: 50));
    isarService.addProduct(Product(name: 'Keyboard', price: 75.00, stock: 30));
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}