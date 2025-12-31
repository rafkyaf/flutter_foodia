import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

// ✅ Pastikan path ini sesuai dengan struktur proyekmu
import 'package:flutter_foodia/presentation/screens/orders/order_list_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  // Use the exact Google Maps link provided by the user
  final Uri _mapsUri = Uri.parse('https://www.google.com/maps/@-7.7725696,110.3757312,12z?entry=ttu&g_ep=EgoyMDI1MTIwOS4wIKXMDSoASAFQAw%3D%3D');

  // A free static map image (OpenStreetMap) for visual preview without API keys
  final String _staticMapUrl = 'https://staticmap.openstreetmap.de/staticmap.php?center=-7.7725696,110.3757312&zoom=12&size=800x400&markers=-7.7725696,110.3757312,red-pushpin';

  // Used to force reload of Image.network when pressing 'Muat Ulang'
  int _mapReload = 0;

  Future<void> _launchMaps() async {
    try {
      // Web needs a different approach to reliably open a new tab/window
      if (kIsWeb) {
        // launchUrlString opens a new tab when webOnlyWindowName is provided
        final url = _mapsUri.toString();
        final launched = await launchUrlString(url, webOnlyWindowName: '_blank');
        if (!launched) throw 'Gagal membuka $url';
      } else {
        // Mobile/desktop: prefer external application, fallback to platformDefault
        final launched = await launchUrl(_mapsUri, mode: LaunchMode.externalApplication);
        if (!launched) {
          final fallback = await launchUrl(_mapsUri, mode: LaunchMode.platformDefault);
          if (!fallback) throw 'Gagal membuka ${_mapsUri.toString()}';
        }
      }
    } catch (e) {
      debugPrint('Map launch error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tidak dapat membuka Google Maps: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double mapHeight = math.min(260, MediaQuery.of(context).size.height * 0.35);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 AppBar custom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "Track Order",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // 🔹 Lokasi & waktu estimasi
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delhi/India",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text("3252 Shakti Nagar",
                              style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.timer, color: Colors.blueAccent),
                      SizedBox(height: 4),
                      Text("Arrive time",
                          style: TextStyle(color: Colors.black54)),
                      Text("15-20 min",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Static map preview (web-friendly) — replaces GoogleMap to avoid web runtime errors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: mapHeight,
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // tappable static map preview (larger)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => MapFullScreen(mapUri: _mapsUri, staticMapUrl: _staticMapUrl),
                          ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _staticMapUrl,
                            key: ValueKey(_mapReload),
                            height: mapHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                height: mapHeight,
                                width: double.infinity,
                                color: Colors.grey[100],
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            },
                            errorBuilder: (context, error, stack) {
                              debugPrint('Static map load error: $error');
                              return GestureDetector(
                                onTap: _launchMaps,
                                child: Container(
                                  height: mapHeight,
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/images/delivery.png', height: 84, width: 84, fit: BoxFit.contain),
                                        const SizedBox(height: 12),
                                        const Text('Gagal memuat peta', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 8),

                                        // Action buttons
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            OutlinedButton(
                                              onPressed: _launchMaps,
                                              child: const Text('Buka di Maps'),
                                            ),
                                            const SizedBox(width: 8),
                                            TextButton(
                                              onPressed: () => setState(() { _mapReload++; }),
                                              child: const Text('Muat Ulang'),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                                          child: Text(
                                            'Jika URL yang digunakan adalah halaman Google Maps (bukan image), gunakan Google Static Maps API atau OpenStreetMap static image.',
                                            style: TextStyle(color: Colors.black38, fontSize: 11),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // small white card with estimated time (slightly inset)
                      Positioned(
                        top: 14,
                        left: 18,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))]),
                          child: Column(
                            children: const [
                              Text('Estimated Time', style: TextStyle(fontSize: 12, color: Colors.black54)),
                              SizedBox(height: 4),
                              Text('5-10 min', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),

                      // 'View larger map' label in the top-left corner
                      Positioned(
                        top: 12,
                        left: 12,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => MapFullScreen(mapUri: _mapsUri, staticMapUrl: _staticMapUrl),
                            ));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0,2))]),
                            child: Row(
                              children: const [
                                Icon(Icons.open_in_new, size: 14, color: Colors.black54),
                                SizedBox(width: 6),
                                Text('View larger map', style: TextStyle(fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // driver info card overlapping bottom of the map
                      Positioned(
                        bottom: -(mapHeight * 0.12),
                        left: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            // placeholder tap - could open driver details
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            height: 76,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))]),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundImage: AssetImage('assets/images/james_profile.jpg'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('Frick Khan', style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 4),
                                      Text('ID 2445556', style: TextStyle(color: Colors.black54, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.blueAccent,
                                        child: IconButton(
                                          onPressed: () {
                                            // call action (implement later)
                                          },
                                          icon: const Icon(Icons.call, size: 18, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.blueGrey[50],
                                      child: IconButton(
                                        onPressed: () {
                                          // chat action (implement later)
                                        },
                                        icon: const Icon(Icons.message, size: 18, color: Colors.blueAccent),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Color(0xFFEDEFF2)),
            const SizedBox(height: 12),

            // 🔹 Order Status
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Order Status",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Timeline status pesanan (Delivered highlighted at top)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: [
                    // Delivered card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(color: Colors.blueAccent.withAlpha(242), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Delivered', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('Aug 8,2022 - 12:20pm', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Other timeline steps
                    const _StatusTile(isDone: true, title: 'Order Recived', time: 'Aug 8, 2022 - 12:10pm', isLast: false),
                    const SizedBox(height: 6),
                    const _StatusTile(isDone: false, title: 'Order Confirmed', time: 'Aug 8, 2022 - 12:15pm', isLast: false),
                    const SizedBox(height: 6),
                    const _StatusTile(isDone: false, title: 'Order Processed', time: 'Aug 8, 2022 - 12:20pm', isLast: false),
                    const SizedBox(height: 6),
                    const _StatusTile(isDone: false, title: 'Order Delivered', time: 'Aug 8, 2022 - 12:20pm', isLast: true),
                  ],
                ),
              ),
            ),

            // 🔹 Tombol Confirm Delivery
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    debugPrint('[TrackOrder] Confirm Delivery pressed, navigating to /product');
                    Navigator.pushReplacementNamed(context, '/product');
                  },

                  child: const Text(
                    "CONFIRM DELIVERY",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: const Center(
        child: Text('Order list placeholder'),
      ),
    );
  }
}

// Full-screen map view (photo 2). Tapping the driver card navigates to driver details.
class MapFullScreen extends StatelessWidget {
  final Uri mapUri;
  final String staticMapUrl;

  const MapFullScreen({Key? key, required this.mapUri, required this.staticMapUrl}) : super(key: key);

  Future<void> _openMaps(BuildContext context) async {
    try {
      if (kIsWeb) {
        final url = mapUri.toString();
        final launched = await launchUrlString(url, webOnlyWindowName: '_blank');
        if (!launched) throw 'Gagal membuka $url';
      } else {
        final launched = await launchUrl(mapUri, mode: LaunchMode.externalApplication);
        if (!launched) {
          final fallback = await launchUrl(mapUri, mode: LaunchMode.platformDefault);
          if (!fallback) throw 'Gagal membuka ${mapUri.toString()}';
        }
      }
    } catch (e) {
      debugPrint('Map launch error (full): $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tidak dapat membuka Google Maps: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () => _openMaps(context),
            tooltip: 'Open in Maps',
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1,
              maxScale: 6,
              child: Image.network(
                staticMapUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(color: Colors.grey[100], child: const Center(child: CircularProgressIndicator()));
                },
                errorBuilder: (context, error, stack) {
                  debugPrint('Full static map load error: $error');
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: Text('Gagal memuat peta', style: TextStyle(color: Colors.black54))),
                  );
                },
              ),
            ),
          ),

          // Driver info bottom sheet card
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverDetailScreen()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6))]),
                child: Row(
                  children: [
                    CircleAvatar(radius: 26, backgroundImage: AssetImage('assets/images/james_profile.jpg')),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Erick Khan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('ID 2445556', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Call action')));
                          },
                          icon: const Icon(Icons.call, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message action')));
                          },
                          icon: const Icon(Icons.message, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple driver detail screen shown when tapping the card on the full map.
class DriverDetailScreen extends StatelessWidget {
  const DriverDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 36, backgroundImage: AssetImage('assets/images/james_profile.jpg')),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Erick Khan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('ID 2445556', style: TextStyle(color: Colors.black54)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calling...')));
              },
              icon: const Icon(Icons.call),
              label: const Text('Call Driver'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening chat...')));
              },
              icon: const Icon(Icons.message),
              label: const Text('Message Driver'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final bool isDone;
  final String title;
  final String time;
  final bool isLast;

  const _StatusTile({
    required this.isDone,
    required this.title,
    required this.time,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone ? Colors.blueAccent : Colors.grey,
              size: 22,
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                  color: isDone ? Colors.black : Colors.grey[600],
                ),
              ),
              Text(
                time,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
