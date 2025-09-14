import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market/features/cart/presentation/providers/cart_provider.dart';
import 'package:market/features/cart/presentation/screens/checkout_screen.dart';

// Custom formatter to limit the quantity to the available stock
class QuantityInputFormatter extends TextInputFormatter {
  final int max; 
  QuantityInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }
    if (value > max) {
      return oldValue;
    }
    return newValue;
  }
}

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final cartTotal = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final controller = TextEditingController(text: item.quantity.toString());
                controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));

                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('Stock: ${item.product.stock} | \$${item.product.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cartNotifier.decrementQuantity(item.product.id),
                      ),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: controller,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            QuantityInputFormatter(item.product.stock),
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              final quantity = int.tryParse(value) ?? 0;
                              cartNotifier.setQuantity(item.product.id, quantity);
                            }
                          },
                          onFieldSubmitted: (value) {
                             if (value.isEmpty) {
                               cartNotifier.setQuantity(item.product.id, 1);
                             }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cartNotifier.incrementQuantity(item.product.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0,16.0,16.0,150.0),
            child: Column(
              children: [
                Text(
                  'Total: \$${cartTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: cartItems.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CheckoutScreen(),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}