
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market/features/cart/presentation/providers/cart_provider.dart';
import 'package:market/features/products/presentation/providers/product_providers.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  Future<void> _simulatePayment(BuildContext context, WidgetRef ref) async {
    // Show a processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Processing payment..."),
              ],
            ),
          ),
        );
      },
    );

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Close the processing dialog
    Navigator.of(context, rootNavigator: true).pop();

    // Execute checkout logic
    final cartItems = ref.read(cartProvider);
    await ref.read(productsProvider.notifier).checkout(cartItems);
    ref.read(cartProvider.notifier).clearCart();

    // Navigate back and show confirmation
    if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checkout Successful!')),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Purchase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text('Total Items: ${cartNotifier.totalItems}'),
            Text(
              'Total Amount: \$${cartNotifier.totalItems.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 40),
            Text(
              'Select Payment Method',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.paypal, color: Colors.blueAccent),
                title: const Text('PayPal'),
                onTap: () => _simulatePayment(context, ref),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.credit_card, color: Colors.orangeAccent),
                title: const Text('Visa'),
                onTap: () => _simulatePayment(context, ref),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.credit_card, color: Colors.redAccent),
                title: const Text('Mastercard'),
                onTap: () => _simulatePayment(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
