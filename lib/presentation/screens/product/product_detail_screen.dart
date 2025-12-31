import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../data/models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel? product;
  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product ?? ProductModel(id: '0', name: 'Chicken Briyani', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', price: 5.8, imageUrl: 'https://images.unsplash.com/photo-1604908177076-5fe5e3bd0d57?q=80&w=1200&auto=format&fit=crop&ixlib=rb-4.0.3&s=');

    // responsive image height so small viewports don't make the content overflow
    final imageHeight = math.min(320.0, MediaQuery.of(context).size.height * 0.45);

    // Place the content card just below the image (no overlap) so the image remains fully visible
    final topOffset = imageHeight + 12.0;
    final bottomOffset = MediaQuery.of(context).viewPadding.bottom + 16;

    // compute available height for the card area (helps avoid RenderFlex overflow)
    final availableCardHeight = MediaQuery.of(context).size.height - topOffset - bottomOffset;
    // leave room for a sticky bottom panel + button (approx 140px)
    final contentMaxHeight = availableCardHeight > 0 ? (availableCardHeight - 140.0).clamp(240.0, availableCardHeight) : 400.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Stack(
        children: [

          // Top image
          SizedBox(
            height: imageHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/chicken_wings.png',
                  image: p.imageUrl,
                  fit: BoxFit.cover,
                  // show local placeholder when network image fails (common on web due to CORS)
                  imageErrorBuilder: (c, e, s) => Image.asset('assets/images/chicken_wings.png', fit: BoxFit.cover),
                ),
                Container(color: const Color.fromRGBO(0, 0, 0, 0.18)),

                // dots indicator
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i==1 ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i==1 ? Colors.white : const Color.fromRGBO(255, 255, 255, 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )),
                  ),
                ),

                // AppBar actions
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.9),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black87),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Product Detail', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 0.9),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.black87),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content card
          Positioned(
            top: topOffset,
            left: 0,
            right: 0,
            bottom: bottomOffset,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width >= 600 ? 720 : 420),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: contentMaxHeight),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            const SizedBox(height: 8),

                            // top row: title + price/qty
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // title + description
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Menu name (prominent, blue)
                                      Text(p.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
                                      const SizedBox(height: 6),
                                      // Short description under the title
                                      Text(p.description, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)), maxLines: 2, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),

                                // price block moved to bottom info panel — keep heading only here
                                const SizedBox.shrink(),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // second row: rating, eta, delivery
                            Row(
                              children: [
                                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xFFF0F0F3))), child: Row(children: const [Icon(Icons.star, color: Color(0xFFFFC134), size: 16), SizedBox(width: 6), Text('4.5', style: TextStyle(fontWeight: FontWeight.w600))])),
                                const SizedBox(width: 12),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xFFF0F0F3))), child: Row(children: const [Icon(Icons.schedule, size: 14, color: Color(0xFF9AA0AA)), SizedBox(width: 6), Text('6-7 Min', style: TextStyle(color: Color(0xFF6B7280)))])),
                                const SizedBox(width: 12),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xFFF0F0F3))), child: Row(children: const [Icon(Icons.local_shipping, size: 14, color: Color(0xFF34C759)), SizedBox(width: 6), Text('FREE DELIVERY', style: TextStyle(color: Color(0xFF34C759), fontWeight: FontWeight.w600))])),
                              ],
                            ),

                            const SizedBox(height: 12),



                            // Price row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Price', style: TextStyle(color: Color(0xFF6B7280))),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Text('\$${p.price.toStringAsFixed(1)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 8),
                                          Text('\$${(p.price * 1.25).toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF9AA0AA), decoration: TextDecoration.lineThrough)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    children: [
                                      GestureDetector(onTap: () { if (_qty > 1) setState(() => _qty--); }, child: const Icon(Icons.remove, size: 18, color: Color(0xFF6B7280))),
                                      const SizedBox(width: 12),
                                      Text('$_qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(width: 12),
                                      GestureDetector(onTap: () { setState(() => _qty++); }, child: const Icon(Icons.add, size: 18, color: Color(0xFF50B6FF))),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Promo row: left badge, apply code on right
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0xFFFF7B72), borderRadius: BorderRadius.circular(6)),
                                  child: const Text('20% OFF DISCOUNT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                                const Spacer(),
                                TextButton(onPressed: (){}, child: const Text('Apply promo code', style: TextStyle(color: Color(0xFF50B6FF), fontWeight: FontWeight.bold)))
                              ],
                            ),

                            const SizedBox(height: 12),

                            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                            const SizedBox(height: 12),

                            // Detail section (moved description here to separate from heading)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text(p.description, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width >= 600 ? 720 : 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Price / discount / qty panel
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 8, offset: const Offset(0, 2))]),
                  child: Row(
                    children: [
                      // Price info + name/estimation
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Menu name
                            Text(p.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),

                            // Estimasi + Free delivery
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xFFF0F0F3))),
                                  child: Row(children: const [Icon(Icons.schedule, size: 14, color: Color(0xFF9AA0AA)), SizedBox(width: 6), Text('6-7 Min', style: TextStyle(color: Color(0xFF6B7280)))]),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xFFF0F0F3))),
                                  child: Row(children: const [Icon(Icons.local_shipping, size: 14, color: Color(0xFF34C759)), SizedBox(width: 6), Text('FREE DELIVERY', style: TextStyle(color: Color(0xFF34C759), fontWeight: FontWeight.w600))]),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Price + discount (existing)
                            Text('\$${(p.price * _qty).toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text('\$${(p.price * 1.25 * _qty).toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF9AA0AA), decoration: TextDecoration.lineThrough)),
                                const SizedBox(width: 8),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFFF7B72), borderRadius: BorderRadius.circular(6)), child: const Text('20% OFF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Qty selector
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () { if (_qty > 1) setState(() => _qty--); },
                              child: const Icon(Icons.remove, size: 18, color: Color(0xFF6B7280)),
                            ),
                            const SizedBox(width: 12),
                            Text('$_qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () { setState(() => _qty++); },
                              child: const Icon(Icons.add, size: 18, color: Color(0xFF50B6FF)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Place Order button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF50B6FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF50B6FF), size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text('PLACE ORDER', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}