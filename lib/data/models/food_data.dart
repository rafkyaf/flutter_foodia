import 'package:flutter/material.dart';

class FoodData {
  static final List<Map<String, dynamic>> categories = [
    {'name': 'Foods', 'icon': Icons.fastfood},
    {'name': 'Drink', 'icon': Icons.local_cafe},
    {'name': 'Snack', 'icon': Icons.restaurant},
    {'name': 'Dessert', 'icon': Icons.cake},
    {'name': 'Food', 'icon': Icons.dining},
  ];

  static final List<Map<String, dynamic>> recommendedFoods = [
    {
      'name': 'Deluxe Burger with Extra',
      'image': 'assets/images/food1.png',
      'rating': 4.6,
      'price': 10.9,
    },
    {
      'name': 'Beef & Eggs',
      'image': 'assets/images/food2.png',
      'rating': 4.6,
      'price': 12.9,
    },
  ];

  static final List<Map<String, dynamic>> trendingFoods = [
    {
      'name': 'Nasi Goreng Kampung',
      'image': 'assets/images/nasgor1.jpg',
      'price': 5.0,
    },
    {
      'name': 'Mie Kuah Becek Spesial\nTelur + Sosis',
      'image': 'assets/images/mie1.jpg',
      'price': 5.0,
      'originalPrice': 8.9,
    },
  ];
}