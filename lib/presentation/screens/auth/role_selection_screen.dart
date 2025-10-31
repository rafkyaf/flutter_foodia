// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'login_screen.dart'; // ✅ Import halaman login

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO & TITLE
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logofoodia1.jpg',
                      height: 100,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Foodia',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // TITLE SECTION
              const Text(
                'Continue as',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Choose your role to continue using Foodia. Enjoy the best experience for your needs!',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              const SizedBox(height: 40),

              // ROLE CARDS
              Column(
                children: [
                  // 🔹 CUSTOMER
                  RoleCard(
                    icon: Icons.person,
                    imageAsset: 'assets/images/man customer.png',
                    role: 'CUSTOMER',
                    description: 'Finding food made easier here.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // 🔹 RESTAURANT
                  RoleCard(
                    icon: Icons.restaurant,
                    imageAsset: 'assets/images/waiter restaurant.png',
                    role: 'RESTAURANT',
                    description: 'Serve great food faster here.',
                    onTap: () {
                      // ✅ Arahkan ke halaman login juga
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String? imageAsset;
  final String role;
  final String description;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.icon,
    this.imageAsset,
    required this.role,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Show PNG image inside a circular crop when provided,
            // otherwise fall back to the Icon inside a CircleAvatar.
            imageAsset != null
                ? ClipOval(
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        imageAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.blue[100],
                          child: Icon(
                            icon,
                            size: 30,
                            color: Colors.blue[700] ?? Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue[100],
                    child: Icon(
                      icon,
                      size: 30,
                      color: Colors.blue[700] ?? Colors.blue,
                    ),
                  ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
