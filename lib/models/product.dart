import 'package:isar/isar.dart';

part 'product.g.dart';

@collection
class Product {
  Id id = Isar.autoIncrement;
  String name;
  double price;
  int stock;

  Product({required this.name, required this.price, required this.stock});
}