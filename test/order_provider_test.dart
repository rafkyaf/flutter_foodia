import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_foodia/providers/order_provider.dart';
import 'package:flutter_foodia/repositories/order_repository_impl.dart';
import 'package:flutter_foodia/data/models/order_model.dart';

void main() {
  group('OrderProvider Tests', () {
    late OrderProvider orderProvider;
    late OrderRepositoryImpl repository;

    setUp(() {
      repository = OrderRepositoryImpl();
      orderProvider = OrderProvider(repository);
    });

    test('Initial state should be empty and not loading', () {
      expect(orderProvider.orders, isEmpty);
      expect(orderProvider.isLoading, false);
      expect(orderProvider.error, isNull);
    });

    test('Fetch orders should populate orders list', () async {
      await orderProvider.fetchOrders();
      
      expect(orderProvider.isLoading, false);
      expect(orderProvider.orders, isNotEmpty);
      expect(orderProvider.error, isNull);
    });

    test('Fetch orders by status ON_DELIVERY should return only delivery orders', () async {
      await orderProvider.fetchOrdersByStatus('ON_DELIVERY');
      
      expect(orderProvider.isLoading, false);
      expect(orderProvider.orders, isNotEmpty);
      
      for (final order in orderProvider.orders) {
        expect(order.status, 'ON_DELIVERY');
      }
    });

    test('Fetch orders by status COMPLETED should return only completed orders', () async {
      await orderProvider.fetchOrdersByStatus('COMPLETED');
      
      expect(orderProvider.isLoading, false);
      expect(orderProvider.orders, isNotEmpty);
      
      for (final order in orderProvider.orders) {
        expect(order.status, 'COMPLETED');
      }
    });

    test('Current orders getter should return only non-completed orders', () async {
      await orderProvider.fetchOrders();
      
      final currentOrders = orderProvider.currentOrders;
      
      for (final order in currentOrders) {
        expect(order.status, isNot('COMPLETED'));
        expect(order.status, isNot('CANCELLED'));
      }
    });

    test('Order history getter should return only completed orders', () async {
      await orderProvider.fetchOrders();
      
      final history = orderProvider.orderHistory;
      
      for (final order in history) {
        expect(['COMPLETED', 'CANCELLED'].contains(order.status), true);
      }
    });

    test('Create order should add order to list', () async {
      final newOrder = Order(
        id: '#TEST123',
        status: 'ON_DELIVERY',
        items: [
          OrderItem(
            name: 'Test Item',
            image: 'https://example.com/image.jpg',
            price: 10.0,
            oldPrice: 15.0,
            quantity: 1,
          ),
        ],
        createdAt: DateTime.now(),
      );

      await orderProvider.createOrder(newOrder);
      
      expect(orderProvider.orders, isNotEmpty);
      expect(orderProvider.orders.any((order) => order.id == '#TEST123'), true);
    });

    test('Order total amount should be calculated correctly', () {
      final order = Order(
        id: '#TEST123',
        status: 'ON_DELIVERY',
        items: [
          OrderItem(
            name: 'Item 1',
            image: 'https://example.com/image.jpg',
            price: 10.0,
            oldPrice: 15.0,
            quantity: 2,
          ),
          OrderItem(
            name: 'Item 2',
            image: 'https://example.com/image.jpg',
            price: 5.0,
            oldPrice: 8.0,
            quantity: 3,
          ),
        ],
        createdAt: DateTime.now(),
      );

      expect(order.totalAmount, 35.0); // (10 * 2) + (5 * 3) = 35
    });

    test('Order total items should be calculated correctly', () {
      final order = Order(
        id: '#TEST123',
        status: 'ON_DELIVERY',
        items: [
          OrderItem(
            name: 'Item 1',
            image: 'https://example.com/image.jpg',
            price: 10.0,
            oldPrice: 15.0,
            quantity: 2,
          ),
          OrderItem(
            name: 'Item 2',
            image: 'https://example.com/image.jpg',
            price: 5.0,
            oldPrice: 8.0,
            quantity: 3,
          ),
        ],
        createdAt: DateTime.now(),
      );

      expect(order.totalItems, 5); // 2 + 3 = 5
    });
  });
}
