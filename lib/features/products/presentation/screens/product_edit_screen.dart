import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market/models/product.dart';
import 'package:market/features/products/presentation/providers/product_providers.dart';

class ProductEditScreen extends ConsumerStatefulWidget {
  final Product? product;

  const ProductEditScreen({super.key, this.product});

  @override
  ConsumerState<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends ConsumerState<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '');
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final price = double.parse(_priceController.text);
      final stock = int.parse(_stockController.text);

      final productNotifier = ref.read(productsProvider.notifier);

      if (widget.product == null) {
        // Create
        productNotifier.addProduct(Product(name: name, price: price, stock: stock));
      } else {
        // Update
        final updatedProduct = widget.product!;
        updatedProduct.name = name;
        updatedProduct.price = price;
        updatedProduct.stock = stock;
        productNotifier.updateProduct(updatedProduct);
      }
      Navigator.of(context).pop();
    }
  }

  void _deleteProduct() {
    if (widget.product != null) {
      ref.read(productsProvider.notifier).deleteProduct(widget.product!.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'New Product' : 'Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProduct,
          ),
          if (widget.product != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteProduct,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid stock quantity';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}