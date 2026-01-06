import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('Signed in as'),
            subtitle: Text(Provider.of<AuthProvider>(context).user?['email'] ?? 'Guest'),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text('Logout'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Provider.of<AuthProvider>(context, listen: false).logout();
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
