import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/product_provider.dart';
import '../../../data/models/product_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _query = '';
  String _selectedCategory = 'Foods';

  // Filter state
  String _filterCategory = 'Ramen';
  String? _filterCookingTime;
  Set<String> _filterDiets = {};
  String? _filterCalories;
  double _filterRating = 0;
  RangeValues _priceRange = const RangeValues(0, 100);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final all = provider.products;
    final filtered = all.where((p) {
      final q = _query.trim().toLowerCase();
      if (q.isNotEmpty && !p.name.toLowerCase().contains(q)) return false;
      if (_selectedCategory == 'Foods' && p.name.toLowerCase().contains('coffee')) return false; // simple demo rules
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87), onPressed: () => Navigator.of(context).maybePop()),
        title: const Text('Product', style: TextStyle(color: Colors.black87)),
        actions: [
          Stack(
            children: [
              IconButton(onPressed: () => Navigator.pushNamed(context, '/cart'), icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87)),
              Positioned(right: 8, top: 8, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
            ],
          ),
          IconButton(onPressed: _openFilterModal, icon: const Icon(Icons.filter_list, color: Colors.black87)),
        ],
      ),
      body: Builder(builder: (ctx) {
        try {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search beverages or foods',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),

                // Chips
                Row(
                  children: [
                    _categoryChip('Foods', Icons.fastfood),
                    const SizedBox(width: 8),
                    _categoryChip('Drink', Icons.local_cafe),
                    const SizedBox(width: 8),
                    _categoryChip('Snacks', Icons.emoji_food_beverage),
                  ],
                ),

                const SizedBox(height: 16),
                const Text('Expression & Classic', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // List of products
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final ProductModel p = filtered[index];
                    final String name = p.name;
                    final String tagsText = (p.tags != null && p.tags!.isNotEmpty) ? p.tags!.join(', ') : 'Coffee, Milk';
                    final bool hasImage = p.imageUrl.isNotEmpty;

                    return InkWell(
                      onTap: () {
                        debugPrint('[ProductList] opening product: ${p.id}');
                        Navigator.pushNamed(context, '/product-detail', arguments: p);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            // Left: Title / subtitle / price & rating
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  Text(tagsText, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text('\$${p.price.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 8),
                                      Text('\$8.9', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey.shade400, fontSize: 12)),
                                      const Spacer(),
                                      const Icon(Icons.star, color: Color(0xFFFFC134), size: 16),
                                      const SizedBox(width: 6),
                                      const Text('4.5', style: TextStyle(color: Color(0xFF6B7280))),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Right: Image with heart overlay and optional second thumb
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: hasImage
                                      ? Image.network(
                                          p.imageUrl,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) => Container(color: Colors.grey[200], width: 90, height: 90),
                                        )
                                      : Container(width: 90, height: 90, color: Colors.grey[200]),
                                ),

                                // Favorite heart at top-right
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: const Icon(Icons.favorite_border, size: 18, color: Color(0xFF6B7280)),
                                  ),
                                ),

                                // Optional small second thumbnail bottom-left
                                if ((p.imageUrl2?.isNotEmpty ?? false))
                                  Positioned(
                                    left: 6,
                                    bottom: 6,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        p.imageUrl2!,
                                        width: 28,
                                        height: 28,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(color: Colors.grey[200], width: 28, height: 28),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
                const Text('Cold Brew', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Builder(
                  builder: (context) {
                    final coldBrews = provider.products.where((p) => p.tags != null && p.tags!.contains('Cold Brew')).toList();
                    if (coldBrews.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: coldBrews
                          .map((p) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _coldBrewCard(p),
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          );
        } catch (e, st) {
          debugPrint('ProductList build error: $e');
          debugPrint('$st');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text('An error occurred while rendering the Product list:\n${e.toString()}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () => (ctx as Element).markNeedsBuild(), child: const Text('Retry')),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _coldBrewCard(ProductModel p) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/product-detail', arguments: p);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(p.tags != null && p.tags!.isNotEmpty ? p.tags!.join(', ') : 'Coffee, Milk', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('\$${p.price.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text('\$8.9', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey.shade400, fontSize: 12)),
                      const Spacer(),
                      const Icon(Icons.star, color: Color(0xFFFFC134), size: 16),
                      const SizedBox(width: 6),
                      const Text('4.5', style: TextStyle(color: Color(0xFF6B7280))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: p.imageUrl.isNotEmpty
                      ? Image.network(
                          p.imageUrl,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(color: Colors.grey[200], width: 90, height: 90),
                        )
                      : Container(width: 90, height: 90, color: Colors.grey[200]),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border, size: 18, color: Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryChip(String label, IconData icon) {
    final selected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF8FF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? const Color(0xFF50B6FF) : const Color(0xFFEDEFF3)),
        ),
        child: Row(children: [Icon(icon, size: 18, color: selected ? const Color(0xFF50B6FF) : const Color(0xFF9AA0AA)), const SizedBox(width: 8), Text(label, style: TextStyle(color: selected ? const Color(0xFF50B6FF) : const Color(0xFF6B7280), fontWeight: selected ? FontWeight.bold : FontWeight.normal))]),
      ),
    );
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        // Use a local state inside the modal to avoid mid-modal parent updates and null surprises
        return StatefulBuilder(builder: (ctxModal, setModalState) {
          try {
            final categories = [
              {'label': 'Ramen', 'emoji': '🍜'},
              {'label': 'Nasi Goreng', 'emoji': '🍛'},
              {'label': 'Burger', 'emoji': '🍔'},
              {'label': 'Pizza', 'emoji': '🍕'},
            ];

            String tempCategory = _filterCategory.isNotEmpty ? _filterCategory : categories.first['label']!;
            String? tempCooking = _filterCookingTime;
            Set<String> tempDiets = Set.from(_filterDiets);
            String? tempCalories = _filterCalories;
            double tempRating = _filterRating;
            RangeValues tempRange = _priceRange;

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctxModal).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(ctxModal).size.height * 0.75,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text('Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctxModal)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Make the main content scrollable to avoid overflow on small screens/keyboard
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category dropdown with emoji icon
                            DropdownButtonFormField<String>(
                              initialValue: tempCategory,
                              items: categories
                                  .map((m) => DropdownMenuItem<String>(
                                        value: m['label']!,
                                        child: Row(children: [Text(m['emoji'] ?? ''), const SizedBox(width: 8), Text(m['label'] ?? '')]),
                                      ))
                                  .toList(),
                              onChanged: (v) => setModalState(() => tempCategory = v ?? tempCategory),
                              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                            ),
                            const SizedBox(height: 12),

                            const Text('Cooking Time', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: ['Under 15 mins', 'Under 30 mins', 'Under 45 mins', 'Under 60 mins']
                                  .map((t) => ChoiceChip(
                                        label: Text(t),
                                        selected: tempCooking == t,
                                        onSelected: (s) => setModalState(() => tempCooking = s ? t : null),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),

                            const Text('Suggested Diets', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: ['Vegetable', 'Low Fat', 'Gluten free', 'Law Cafe', 'Sugar Free']
                                  .map((d) => FilterChip(
                                        label: Text(d),
                                        selected: tempDiets.contains(d),
                                        onSelected: (s) => setModalState(() => s ? tempDiets.add(d) : tempDiets.remove(d)),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),

                            const Text('Calories', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: ['55g Kcal', '65g Kcal', '70g Kcal', '80g Kcal']
                                  .map((c) => ChoiceChip(label: Text(c), selected: tempCalories == c, onSelected: (s) => setModalState(() => tempCalories = s ? c : null)))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),

                            const Text('Ratings', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: ['4.3', '4.5', '4.7', '5.0']
                                  .map((r) => ChoiceChip(
                                        label: Row(children: [const Icon(Icons.star, color: Color(0xFFFFC134), size: 16), const SizedBox(width: 4), Text(r)]),
                                        selected: tempRating.toString() == r,
                                        onSelected: (s) => setModalState(() => tempRating = s ? double.parse(r) : 0),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),

                            const Text('Pricing Table', style: TextStyle(fontWeight: FontWeight.bold)),
                            RangeSlider(
                              values: tempRange,
                              min: 0,
                              max: 200,
                              divisions: 20,
                              labels: RangeLabels('\$${tempRange.start.round()}', '\$${tempRange.end.round()}'),
                              onChanged: (v) => setModalState(() => tempRange = v),
                            ),

                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _filterCookingTime = null;
                                _filterDiets.clear();
                                _filterCalories = null;
                                _filterRating = 0;
                                _priceRange = const RangeValues(0, 100);
                              });
                              Navigator.pop(ctxModal);
                            },
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Apply local selection to parent state
                              setState(() {
                                _filterCategory = tempCategory;
                                _filterCookingTime = tempCooking;
                                _filterDiets = tempDiets;
                                _filterCalories = tempCalories;
                                _filterRating = tempRating;
                                _priceRange = tempRange;
                              });
                              Navigator.pop(ctxModal);
                            },
                            child: const Text('Apply Filter'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } catch (e, st) {
            debugPrint('Filter modal error: $e');
            debugPrint('$st');
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('Unable to open filter: ${e.toString()}', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: () => Navigator.pop(ctxModal), child: const Text('Close')),
                ],
              ),
            );
          }
        });
      },
    );
  }
}
