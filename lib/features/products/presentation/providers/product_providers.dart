import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market/features/cart/presentation/providers/cart_provider.dart';
import 'package:market/features/products/data/repositories/product_repository.dart';
import 'package:market/models/product.dart';
import 'package:market/services/isar_service.dart';

// Enums and Providers for filtering
enum ProductStockFilter { all, inStock, outOfStock, inCart }

final productSearchProvider = StateProvider<String>((ref) => '');
final productStockFilterProvider = StateProvider<ProductStockFilter>((ref) => ProductStockFilter.all);

// Provider for the IsarService
final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService();
});

// Provider for the ProductRepository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return ProductRepository(isarService);
});

// The main provider for products, now an AsyncNotifierProvider
final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(() {
  return ProductsNotifier();
});

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final searchQuery = ref.watch(productSearchProvider);
    final stockFilter = ref.watch(productStockFilterProvider);
    final cartItems = ref.watch(cartProvider);

    // Fetch initial list based on text search
    final allProducts = await ref.read(productRepositoryProvider).getProducts(filter: searchQuery);

    // Apply secondary filter
    switch (stockFilter) {
      case ProductStockFilter.inStock:
        return allProducts.where((p) => p.stock > 0).toList();
      case ProductStockFilter.outOfStock:
        return allProducts.where((p) => p.stock <= 0).toList();
      case ProductStockFilter.inCart:
        final cartProductIds = cartItems.map((item) => item.product.id).toSet();
        return allProducts.where((p) => cartProductIds.contains(p.id)).toList();
      case ProductStockFilter.all:
      default:
        return allProducts;
    }
  }

  Future<void> addProduct(Product product) async {
    state = const AsyncValue.loading();
    await ref.read(productRepositoryProvider).addProduct(product);
    ref.invalidateSelf();
  }

  Future<void> updateProduct(Product product) async {
    state = const AsyncValue.loading();
    await ref.read(productRepositoryProvider).updateProduct(product);
    ref.invalidateSelf();
  }

  Future<void> deleteProduct(int id) async {
    state = const AsyncValue.loading();
    await ref.read(productRepositoryProvider).deleteProduct(id);
    ref.invalidateSelf();
  }

  void setSearchQuery(String query) {
    ref.read(productSearchProvider.notifier).state = query;
  }

   void setStockFilter(ProductStockFilter filter) {
    ref.read(productStockFilterProvider.notifier).state = filter;
  }

  Future<void> checkout(List<CartItem> cartItems) async {
    state = const AsyncValue.loading();
    final productRepo = ref.read(productRepositoryProvider);
    for (final item in cartItems) {
      final updatedProduct = item.product;
      updatedProduct.stock -= item.quantity;
      await productRepo.updateProduct(updatedProduct);
    }
    ref.invalidateSelf();
  }
}