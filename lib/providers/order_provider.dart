import 'package:flutter/foundation.dart';
import '../data/models/order_model.dart';
import '../repositories/order_repository.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _repository;
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  OrderProvider(this._repository);

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get current orders (orders in progress)
  List<Order> get currentOrders => _orders
      .where((order) => order.status != 'COMPLETED' && order.status != 'CANCELLED')
      .toList();

  // Get order history (completed orders)
  List<Order> get orderHistory => _orders
      .where((order) => order.status == 'COMPLETED' || order.status == 'CANCELLED')
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _repository.getOrders();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrdersByStatus(String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _repository.getOrdersByStatus(status);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createOrder(Order order) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.createOrder(order);
      await fetchOrders(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final order = await _repository.getOrderById(orderId);
      final updatedOrder = Order(
        id: order.id,
        status: newStatus,
        items: order.items,
        createdAt: order.createdAt,
      );
      await _repository.updateOrder(updatedOrder);
      await fetchOrders(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
