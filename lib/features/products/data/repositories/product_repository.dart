import 'package:market/models/product.dart';
import 'package:market/services/isar_service.dart';

class ProductRepository {
  final IsarService _isarService;

  ProductRepository(this._isarService);

  Future<List<Product>> getProducts({String? filter}) {
    return _isarService.getProducts(filter: filter);
  }

  Future<void> addProduct(Product product) {
    return _isarService.addProduct(product);
  }

  Future<void> updateProduct(Product product) {
    return _isarService.updateProduct(product);
  }

  Future<void> deleteProduct(int id) {
    return _isarService.deleteProduct(id);
  }
}