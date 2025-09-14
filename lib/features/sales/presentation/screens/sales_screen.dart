
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market/features/cart/presentation/providers/cart_provider.dart';
import 'package:market/features/products/presentation/providers/product_providers.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      ref.read(productsProvider.notifier).setSearchQuery(value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<ProductStockFilter>(
                  value: ref.watch(productStockFilterProvider),
                  onChanged: (ProductStockFilter? newValue) {
                    if (newValue != null) {
                      ref.read(productsProvider.notifier).setStockFilter(newValue);
                    }
                  },
                  items: ProductStockFilter.values
                      .map<DropdownMenuItem<ProductStockFilter>>((ProductStockFilter value) {
                    return DropdownMenuItem<ProductStockFilter>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data: (products) => ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isOutOfStock = product.stock <= 0;
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('Stock: ${product.stock} | \$${product.price.toStringAsFixed(2)}'),
                      trailing: isOutOfStock
                          ? const Text('Out of Stock', style: TextStyle(color: Colors.red))
                          : IconButton(
                              icon: const Icon(Icons.add_shopping_cart),
                              onPressed: () {
                                cartNotifier.addItem(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Added ${product.name} to cart')),
                                );
                              },
                            ),
                      onTap: isOutOfStock ? null : () {
                        cartNotifier.addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added ${product.name} to cart')),
                        );
                      },
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
