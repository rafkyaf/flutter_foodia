import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/order_model.dart';
import '../../../services/notification_service.dart';
import '../../../providers/order_provider.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final _notifService = NotificationService();

  @override
  void initState() {
    super.initState();
    // fetch orders shortly after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<OrderProvider>(context, listen: false);
      provider.fetchOrders();
    });
  }

  void _showNotifications() {
    final notifs = _notifService.getNotifications();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: notifs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final n = notifs[index];
              return ListTile(
                title: Text(n.title),
                subtitle: Text(n.message),
                trailing: n.isRead ? null : const Icon(Icons.fiber_new, color: Colors.red),
                onTap: () {
                  _notifService.markAsRead(n.id);
                  setState(() {});
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _notifService.markAllAsRead();
              setState(() {});
            },
            child: const Text('Mark all read'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Orders'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: _showNotifications,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications),
                  Positioned(
                    right: 0,
                    top: 8,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${_notifService.getUnreadCount()}',
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = provider.orders;
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return RefreshIndicator(
            onRefresh: provider.fetchOrders,
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final o = orders[index];
                return _OrderCard(
                  order: o,
                  onAccept: () async {
                    await provider.updateOrderStatus(o.id, 'ACCEPTED');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order accepted')),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onAccept;

  const _OrderCard({required this.order, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(order.status, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 6),
            Text('Items: ${order.totalItems} • Total: \$${order.totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Created: ${order.createdAt}'),
            const SizedBox(height: 8),
            Text('Payment: ${order.status == 'DONE' ? 'Received' : 'Pending'}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.status != 'ACCEPTED' && order.status != 'DONE')
                  ElevatedButton(
                    onPressed: onAccept,
                    child: const Text('Accept'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
