import 'package:flutter/material.dart';
import '../data/models/product_model.dart';
import '../repositories/mock_product_repository.dart';
class ProductProvider extends ChangeNotifier { final MockProductRepository _repo = MockProductRepository(); List<ProductModel> _products = []; bool _loading = false; List<ProductModel> get products => _products; bool get loading => _loading; ProductProvider() { load(); } Future<void> load() async { _loading = true; notifyListeners(); _products = await _repo.fetchProducts(); _loading = false; notifyListeners(); } }