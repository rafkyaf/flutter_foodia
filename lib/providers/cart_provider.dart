import 'package:flutter/material.dart';
import '../data/models/cart_model.dart';
import '../data/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  List<CartItemModel> get items => List.unmodifiable(_items);

  void add(ProductModel p) {
    final index = _items.indexWhere((e) => e.product.id == p.id);
    if (index >= 0) {
      _items[index].qty++;
    } else {
      _items.add(CartItemModel(product: p));
    }
    notifyListeners();
  }

  void remove(ProductModel p) {
    _items.removeWhere((e) => e.product.id == p.id);
    notifyListeners();
  }

  void updateQuantity(ProductModel p, int quantity) {
    if (quantity <= 0) {
      remove(p);
      return;
    }
    
    final index = _items.indexWhere((e) => e.product.id == p.id);
    if (index >= 0) {
      _items[index].qty = quantity;
      notifyListeners();
    }
  }

  double get total => _items.fold(0, (s, e) => s + e.product.price * e.qty);

  void clear() {
    _items.clear();
    notifyListeners();
  }
}