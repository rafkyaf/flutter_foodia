import '../data/models/order_model.dart';
import 'order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final List<Order> _orders = [
    Order(
      id: '#0012345',
      status: 'ON DELIVERY',
      createdAt: DateTime.now(),
      items: [
        OrderItem(
          name: 'Coffee Mocha / White Mocha',
          image: "assets/images/chicken_wings.png",
          price: 5.0,
          oldPrice: 8.9,
          quantity: 2,
        ),
        OrderItem(
          name: 'Chicken Wings Spicy',
          image: "assets/images/chicken_wings.png",
          price: 5.0,
          oldPrice: 8.9,
          quantity: 2,
        ),
      ],
    ),
    Order(
      id: '#0012346',
      status: 'DONE',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      items: [
        OrderItem(
          name: 'Vanilla Sweet Cream Cold',
          image: "assets/images/chicken_wings.png",
          price: 5.0,
          oldPrice: 8.9,
          quantity: 2,
        ),
        OrderItem(
          name: 'Mily Cream Ice Coffee',
          image: "assets/images/chicken_wings.png",
          price: 5.0,
          oldPrice: 8.9,
          quantity: 2,
        ),
        OrderItem(
          name: 'Deluxe Burger Spicy',
          image: "assets/images/chicken_wings.png",
          price: 5.0,
          oldPrice: 8.9,
          quantity: 2,
        ),
      ],
    ),
  ];

  @override
  Future<List<Order>> getOrders() async {
    // Simulating API delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _orders;
  }

  @override
  Future<Order> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _orders.firstWhere(
      (order) => order.id == id,
      orElse: () => throw Exception('Order not found'),
    );
  }

  @override
  Future<Order> createOrder(Order order) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _orders.insert(0, order);
    return order;
  }

  @override
  Future<Order> updateOrder(Order updatedOrder) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _orders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      _orders[index] = updatedOrder;
      return updatedOrder;
    }
    throw Exception('Order not found');
  }

  @override
  Future<void> deleteOrder(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _orders.removeWhere((order) => order.id == id);
  }

  @override
  Future<List<Order>> getOrdersByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _orders.where((order) => order.status == status).toList();
  }
}
