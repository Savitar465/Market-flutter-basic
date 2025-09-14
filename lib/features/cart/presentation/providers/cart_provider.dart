import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addItem(Product product) {
    if (product.stock <= 0) return; // Do not add if out of stock

    for (var i = 0; i < state.length; i++) {
      if (state[i].product.id == product.id) {
        if (state[i].quantity < product.stock) {
          state[i].quantity++;
          state = [...state];
        }
        return;
      }
    }
    state = [...state, CartItem(product: product)];
  }

  void removeItem(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void incrementQuantity(int productId) {
    for (var i = 0; i < state.length; i++) {
      if (state[i].product.id == productId) {
        if (state[i].quantity < state[i].product.stock) {
          state[i].quantity++;
          state = [...state];
        }
        return;
      }
    }
  }

  void decrementQuantity(int productId) {
    for (var i = 0; i < state.length; i++) {
      if (state[i].product.id == productId) {
        state[i].quantity--;
        if (state[i].quantity == 0) {
          state = state.where((item) => item.product.id != productId).toList();
        } else {
          state = [...state];
        }
        return;
      }
    }
  }

  void setQuantity(int productId, int quantity) {
    for (var i = 0; i < state.length; i++) {
      if (state[i].product.id == productId) {
        if (quantity <= 0) {
          // If quantity is zero or less, remove the item
          state = state.where((item) => item.product.id != productId).toList();
        } else if (quantity <= state[i].product.stock) {
          // Update quantity if it's within stock limits
          state[i].quantity = quantity;
          state = [...state];
        } else {
          // If desired quantity exceeds stock, set to max available stock
          state[i].quantity = state[i].product.stock;
          state = [...state];
        }
        return;
      }
    }
  }

  void clearCart() {
    state = [];
  }

  int get totalItems => state.fold(0, (total, item) => total + item.quantity);

}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});

// Provider that calculates the total price of the cart
final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0, (total, item) => total + item.subtotal);
});