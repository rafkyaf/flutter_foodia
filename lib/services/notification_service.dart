import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime timestamp;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<NotificationItem> _mockNotifications = [
    NotificationItem(
      id: '1',
      title: 'Order Confirmed',
      message: 'Your order #12345 has been confirmed and is being prepared.',
      type: 'order',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationItem(
      id: '2',
      title: 'Special Offer',
      message: 'Get 20% off on your next order! Valid for today only.',
      type: 'promo',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationItem(
      id: '3',
      title: 'Order Delivered',
      message: 'Your order #12344 has been delivered. Enjoy your meal!',
      type: 'order',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationItem(
      id: '4',
      title: 'New Restaurant',
      message: 'Try our new partner restaurant "Tasty Bites" with special opening discount!',
      type: 'info',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<NotificationItem> getNotifications() {
    return List.from(_mockNotifications);
  }

  int getUnreadCount() {
    return _mockNotifications.where((n) => !n.isRead).length;
  }

  void markAsRead(String id) {
    final index = _mockNotifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockNotifications[index] = NotificationItem(
        id: _mockNotifications[index].id,
        title: _mockNotifications[index].title,
        message: _mockNotifications[index].message,
        type: _mockNotifications[index].type,
        timestamp: _mockNotifications[index].timestamp,
        isRead: true,
      );
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _mockNotifications.length; i++) {
      _mockNotifications[i] = NotificationItem(
        id: _mockNotifications[i].id,
        title: _mockNotifications[i].title,
        message: _mockNotifications[i].message,
        type: _mockNotifications[i].type,
        timestamp: _mockNotifications[i].timestamp,
        isRead: true,
      );
    }
  }
}
