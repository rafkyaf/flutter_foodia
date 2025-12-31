import 'product_repository.dart';
import '../data/models/product_model.dart';
class MockProductRepository implements ProductRepository {
  @override
  Future<List<ProductModel>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      ProductModel(
        id: 'p1',
        name: 'Classic Burger',
        description: 'Juicy beef patty with fresh vegetables',
        price: 8.99,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
        imageUrl2: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=500',
        tags: ['Beef', 'Burger'],
      ),
      ProductModel(
        id: 'p2',
        name: 'Chicken Rice Bowl',
        description: 'Grilled chicken with seasoned rice',
        price: 10.99,
        imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500',
        imageUrl2: 'https://images.unsplash.com/photo-1499028344343-cd173ffc68a9?w=500',
        tags: ['Chicken', 'Rice'],
      ),
      ProductModel(
        id: 'p3',
        name: 'Vegetarian Pasta',
        description: 'Fresh pasta with mixed vegetables',
        price: 9.99,
        imageUrl: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=500',
        tags: ['Vegetarian', 'Pasta'],
      ),
      ProductModel(
        id: 'p4',
        name: 'Breakfast Sandwich',
        description: 'Egg and cheese on pretzel bun',
        price: 7.99,
        imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=500',
        tags: ['Breakfast', 'Sandwich'],
      ),
      ProductModel(
        id: 'p5',
        name: 'Fish & Chips',
        description: 'Crispy fish with seasoned fries',
        price: 12.99,
        imageUrl: 'https://images.unsplash.com/photo-1579208575657-c595a05383b7?w=500',
        tags: ['Fish', 'Fries'],
      ),
      ProductModel(
        id: 'cb1',
        name: 'Vanilla Sweet Cream Cold Brew',
        description: 'Smooth cold brew with vanilla sweet cream',
        price: 5.0,
        imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500',
        imageUrl2: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=500',
        tags: ['Coffee', 'Milk', 'Cold Brew'],
      ),
      ProductModel(
        id: 'cb2',
        name: 'Citrus Cold Brew with Extra Cream',
        description: 'Bright citrus notes with extra cream',
        price: 5.0,
        imageUrl: 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=500',
        imageUrl2: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
        tags: ['Coffee', 'Milk', 'Cold Brew'],
      ),
    ];
  }
} 
  