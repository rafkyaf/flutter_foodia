// Clean home screen implementing the requested layout (greeting, search, categories, promos, recommended and trending sections).
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/bottom_nav_screen.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/order_model.dart';
import '../../../services/notification_service.dart';
import '../../../core/constants/profile_images.dart';
import '../auth/role_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../customer/cart/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDarkMode = false;
  String userName = 'James';
  Color _highlightColor = Colors.blue.shade800;
  static const String _prefHighlightColorKey = 'highlight_color';
  static const String _prefDarkModeKey = 'is_dark_mode';

  @override
  void initState() {
    super.initState();
    _loadHighlightColor();
    _loadDarkMode();
  }

  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;
    final auth = context.watch<AuthProvider>();
    String displayName = 'Guest';
    if (auth.user != null) {
      displayName = auth.user!['name'] ?? auth.user!['full_name'] ?? auth.user!['email'] ?? 'User';
    }

    return Theme(
      data: _isDarkMode ? AppTheme.darkTheme : Theme.of(context),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Good Morning', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(width: 4),
                  Icon(Icons.waving_hand_outlined, color: Colors.amber[600], size: 18),
                ],
              ),
              Text(
                displayName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                final user = Provider.of<AuthProvider>(context, listen: false).user;
                bool isAdminRole = false;
                if (user != null) {
                  final roleVal = user['role'] ?? user['type'] ?? user['role_name'] ?? user['is_admin'] ?? user['isAdmin'] ?? user['role_id'];
                  final r = roleVal?.toString().toLowerCase();
                  if (r == 'admin' || r == 'restaurant' || r == 'true') {
                    isAdminRole = true;
                  } else {
                    final rvnum = int.tryParse(r ?? '');
                    if (rvnum != null && rvnum != 1) isAdminRole = true;
                  }
                }
                if (isAdminRole) {
                  Navigator.pushNamed(context, '/admin/orders');
                } else {
                  Navigator.pushNamed(context, '/cart');
                }
              },
              icon: Icon(Icons.shopping_cart_outlined, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
            ),
            IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: Icon(Icons.person_outline, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54)),

          ],
        ),
        drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 12),
              _buildCategoryTabs(),
              const SizedBox(height: 12),
              _buildPromoCards(),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recomended', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/product'),
                      child: const Text('View more'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 190,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      ...products
                          .asMap()
                          .entries
                          .take(6)
                          .map((e) {
                            final isLast = e.key == 5 || e.key == products.length - 1;
                            return Padding(
                              padding: EdgeInsets.only(right: isLast ? 0 : 12),
                              child: _recommendedCard(e.value),
                            );
                          })
                          .toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Trending this week', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: products.take(4).map((p) => _trendingItem(p)).toList(),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/product'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _highlightColor),
                      shape: const StadiumBorder(),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text('VIEW MORE'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewPadding.bottom + 
                    kBottomNavigationBarHeight + 
                    kFloatingActionButtonMargin + 
                    40,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _highlightColor,
        onPressed: () {},
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ),
    );
  }

  Future<void> _loadHighlightColor() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? colorValue = prefs.getInt(_prefHighlightColorKey);
      if (colorValue != null) {
        setState(() {
          _highlightColor = Color(colorValue);
        });
      }
    } catch (_) {}
  }

  Future<void> _saveHighlightColor(Color c) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefHighlightColorKey, c.toARGB32());
    } catch (_) {}
  }

  Future<void> _loadDarkMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool? v = prefs.getBool(_prefDarkModeKey);
      if (v != null) {
        setState(() => _isDarkMode = v);
      }
    } catch (_) {}
  }

  Future<void> _saveDarkMode(bool v) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefDarkModeKey, v);
    } catch (_) {}
  }

  void _openHighlightsPicker([BuildContext? showInContext]) {
    final showContext = showInContext ?? context;

    final options = [
      {'name': 'Default', 'color': Colors.blue},
      {'name': 'Green', 'color': Colors.green},
      {'name': 'Blue', 'color': Colors.lightBlue},
      {'name': 'Pink', 'color': Colors.pinkAccent},
      {'name': 'Yellow', 'color': Colors.yellow},
      {'name': 'Orange', 'color': Colors.deepOrange},
      {'name': 'Purple', 'color': Colors.purple},
      {'name': 'Red', 'color': Colors.red},
      {'name': 'Lightblue', 'color': Colors.lightBlueAccent},
      {'name': 'Teal', 'color': Colors.teal},
      {'name': 'Lime', 'color': Colors.lime},
      {'name': 'Deeporange', 'color': Colors.deepOrangeAccent},
    ];

    showModalBottomSheet(
      context: showContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 6, width: 40, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 12),
              const Text('Choose highlight color', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                height: 320,
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: options.map((opt) {
                    final Color c = (opt['color'] as Color?) ?? Colors.blue;
                    final bool selected = c == _highlightColor;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _highlightColor = c);
                        _saveHighlightColor(c);
                        Navigator.of(ctx).pop();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: selected ? Border.all(color: Colors.black, width: 2) : null),
                              ),
                              if (selected)
                                Positioned(
                                  right: -6,
                                  top: -6,
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0,1))]),
                                    child: Icon(Icons.check, size: 14, color: c),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(opt['name'] as String, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }



  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search beverages or foods',
        prefixIcon: Icon(Icons.search, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black45),
        hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black45),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : const Color(0xFFF6F8FA),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
      onSubmitted: (v) {},
    );
  }

  Widget _buildCategoryTabs() {
    final categories = [
      {'title': 'Foods', 'icon': Icons.restaurant_menu, 'color': Colors.blue},
      {'title': 'Drink', 'icon': Icons.local_cafe, 'color': Colors.red[400]},
      {'title': 'Snack', 'icon': Icons.bakery_dining, 'color': Colors.green},
      {'title': 'Dessert', 'icon': Icons.icecream, 'color': Colors.purple},
      {'title': 'Food', 'icon': Icons.lunch_dining, 'color': Colors.orange},
    ];
    
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/product'),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: (category['color'] as Color?) ?? Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: 60,
                  height: 60,
                  child: Icon(
                    category['icon'] as IconData,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category['title'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoCards() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final isFirst = i == 0;
          final promo = isFirst
              ? {
                  'title': 'Happy Weekend',
                  'discount': '60% OFF',
                  'subtitle': 'For All Menus',
                  'colors': [Color(0xFFFF8A65), Color(0xFFFF7043)],
                }
              : {
                  'title': 'Special Offer',
                  'discount': '40% OFF',
                  'subtitle': 'For New Users',
                  'colors': [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                };

          return Container(
            width: MediaQuery.of(context).size.width * 0.78,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: promo['colors'] as List<Color>),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8, offset: const Offset(0, 3)),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        promo['title'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        promo['discount'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        promo['subtitle'] as String,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.local_offer, color: Colors.white, size: 28),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _recommendedCard(ProductModel p) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product', arguments: p),
      child: Container(
        width: 220,
        decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withAlpha(80) : Colors.grey.withAlpha(20), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    p.imageUrl,
                    height: 80,
                    width: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(height: 80, width: 220, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200]),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700] : Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))]),
                    child: Icon(Icons.favorite_border, size: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : const Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                const SizedBox(height: 6),
                Row(children: [Text('\$${p.price.toStringAsFixed(1)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)), const SizedBox(width: 6), Text('\$8.9', style: TextStyle(decoration: TextDecoration.lineThrough, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[500] : Colors.grey.shade400, fontSize: 10))]),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trendingItem(ProductModel p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withAlpha(60) : Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, '/product', arguments: p),
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: Image.network(
                  p.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[300],
                    child: Icon(Icons.image, size: 40, color: Theme.of(context).brightness == Brightness.dark ? Colors.white38 : null),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              p.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withAlpha(25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber[600], size: 16),
                                const SizedBox(width: 4),
                                const Text(
                                  '4.5',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${p.description.split(' ').take(4).join(' ')}...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${p.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final cart = context.read<CartProvider>();
                              cart.add(p);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${p.name} added to cart'),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'View Cart',
                                    onPressed: () {
                                      final user = Provider.of<AuthProvider>(context, listen: false).user;
                                      bool isAdminRole = false;
                                      if (user != null) {
                                        final roleVal = user['role'] ?? user['type'] ?? user['role_name'] ?? user['is_admin'] ?? user['isAdmin'] ?? user['role_id'];
                                        final r = roleVal?.toString().toLowerCase();
                                        if (r == 'admin' || r == 'restaurant' || r == 'true') {
                                          isAdminRole = true;
                                        } else {
                                          final rvnum = int.tryParse(r ?? '');
                                          if (rvnum != null && rvnum != 1) isAdminRole = true;
                                        }
                                      }
                                      if (isAdminRole) {
                                        Navigator.pushNamed(context, '/admin/orders');
                                      } else {
                                        Navigator.pushNamed(context, '/cart');
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_circle),
                            color: Colors.orange,
                            iconSize: 28,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      elevation: 8,
      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/notification');
                if (!mounted) return;
                setState(() {});
              },
              icon: Icon(Icons.notifications_none, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
            ),
            IconButton(onPressed: () {
                final user = Provider.of<AuthProvider>(context, listen: false).user;
                bool isAdminRole = false;
                if (user != null) {
                  final roleVal = user['role'] ?? user['type'] ?? user['role_name'] ?? user['is_admin'] ?? user['isAdmin'] ?? user['role_id'];
                  final r = roleVal?.toString().toLowerCase();
                  if (r == 'admin' || r == 'restaurant' || r == 'true') {
                    isAdminRole = true;
                  } else {
                    final rvnum = int.tryParse(r ?? '');
                    if (rvnum != null && rvnum != 1) isAdminRole = true;
                  }
                }
                if (isAdminRole) {
                  Navigator.pushNamed(context, '/admin/orders');
                } else {
                  Navigator.pushNamed(context, '/orders');
                }
              }, icon: Icon(Icons.receipt_long, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54)),
            const SizedBox(width: 48), // space for FAB
            // Message icon with unread count
            Builder(builder: (ctx) {
              final unreadMessages = ProfileImages.chatUsers.fold<int>(0, (sum, u) {
                final v = u['unread'];
                if (v == null) return sum;
                return sum + (int.tryParse(v) ?? 0);
              });
              return Stack(
                children: [
                  IconButton(onPressed: () => Navigator.pushNamed(context, '/message'), icon: Icon(Icons.message_outlined, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54)),
                  if (unreadMessages > 0)
                    Positioned(
                      right: 6,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text(unreadMessages.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              );
            }),
            IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: Icon(Icons.person_outline, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    final auth = Provider.of<AuthProvider>(context);
    String displayName = 'Guest';
    if (auth.user != null) {
      displayName = auth.user!['name'] ?? auth.user!['full_name'] ?? auth.user!['email'] ?? 'User';
    }
    Widget iconCircle(IconData icon, Color bg) => Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.white, size: 20),
        );

    Widget badgeIcon(IconData icon, Color bg, {int? count, Color badgeColor = Colors.red}) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          iconCircle(icon, bg),
          if (count == null)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
              ),
            )
          else
            Positioned(
              right: -8,
              top: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white, width: 1.5)),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Center(
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return Drawer(
      width: 300,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: _highlightColor,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.blue[800], size: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Good Morning', style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(displayName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text('MAIN MENU', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
            const SizedBox(height: 6),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: iconCircle(Icons.home, Colors.black87),
                      title: const Text('Welcome'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: iconCircle(Icons.home, Colors.orange),
                      title: const Text('Home'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: iconCircle(Icons.grid_view, Colors.indigo),
                      title: const Text('Pages'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pushNamed(context, '/pages'),
                    ),
                    ListTile(
                      leading: iconCircle(Icons.widgets, Colors.blueGrey),
                      title: const Text('Components'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pushNamed(context, '/components'),
                    ),
                    ListTile(
                      leading: badgeIcon(Icons.notifications_none, Colors.grey, count: 1),
                      title: const Text('Notifications'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pushNamed(context, '/notification'),
                    ),
                    ListTile(
                      leading: iconCircle(Icons.person_outline, Colors.teal),
                      title: Text(auth.user != null ? (auth.user!['name'] ?? auth.user!['email'] ?? 'Profile') : 'Profile'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                    ),
                    ListTile(
                      leading: badgeIcon(Icons.chat_bubble_outline, Colors.purple, count: 5, badgeColor: Colors.purple),
                      title: const Text('Chat'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pushNamed(context, '/message'),
                    ),
                    ListTile(
                      leading: iconCircle(Icons.shopping_cart_checkout, Colors.deepPurple),
                      title: const Text('Checkout'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context);
                        final user = Provider.of<AuthProvider>(context, listen: false).user;
                        bool isAdminRole = false;
                        if (user != null) {
                          final r = (user['role'] ?? user['type'] ?? user['role_name'] ?? user['is_admin'] ?? user['isAdmin']).toString().toLowerCase();
                          if (r == 'admin' || r == 'restaurant' || r == '1' || r == 'true') isAdminRole = true;
                        }
                        if (isAdminRole) {
                          Navigator.pushNamed(context, '/admin/orders');
                        } else {
                          Navigator.pushNamed(context, '/cart');
                        }
                      },
                    ),
                    ListTile(
                      leading: iconCircle(Icons.logout, Colors.redAccent),
                      title: const Text('Logout'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Confirm logout'),
                            content: const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(ctx).pop();
                                  Provider.of<AuthProvider>(context, listen: false).logout();
                                  Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
                                },
                                child: const Text('Logout', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 150), () => _openHighlightsPicker());
                    },
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
                        const SizedBox(width: 12),
                        const Expanded(child: Text('Highlights')),
                        Container(
                          width: 28,
                          height: 16,
                          decoration: BoxDecoration(color: _highlightColor, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.nightlight_round, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : const Color.fromARGB(137, 1, 26, 136)),
                    
                    title: const Text('Appearance'),
                    subtitle: Text(_isDarkMode ? 'Dark mode is enabled' : 'Light mode is enabled', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54)),

                    trailing: Switch.adaptive(
                      value: _isDarkMode,
                      activeThumbColor: _highlightColor,
                      onChanged: (v) {
                        setState(() {
                          _isDarkMode = v;
                        });
                        _saveDarkMode(v);
                      },
                    ),
                    onTap: () {
                      final newVal = !_isDarkMode;
                      setState(() => _isDarkMode = newVal);
                      _saveDarkMode(newVal);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}