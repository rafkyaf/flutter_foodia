import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/logofoodia1.jpg',
              fit: BoxFit.cover,              errorBuilder: (context, error, stack) {
                debugPrint('[SplashLogo] asset load error: $error');
                return Container(
                  color: const Color(0xFF50B6FF),
                  child: const Center(child: Icon(Icons.restaurant_menu, color: Colors.white, size: 50)),
                );
              },            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Foodia",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
