import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Library Peta Gratis (OSM)
import 'package:latlong2/latlong.dart'; // Helper untuk koordinat
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_foodia/presentation/screens/orders/order_list_screen.dart'; // Sesuaikan jika perlu

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  // Koordinat Lokasi (Contoh: Bundaran UGM Yogyakarta)
  // Tidak butuh API Key, cukup masukkan LatLng
  final LatLng _centerLocation = const LatLng(-7.7725696, 110.3757312);
  final LatLng _driverLocation = const LatLng(-7.7700000, 110.3740000);

  @override
  Widget build(BuildContext context) {

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

            // 🔹 Detail Lokasi & Waktu
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                            "Lokasi Tujuan",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text("Yogyakarta, Indonesia",
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
                      Text("Estimasi", style: TextStyle(color: Colors.black54)),
                      Text("15-20 mnt",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 AREA PETA MINI (CARD) — mirip foto 1
            GestureDetector(
              onTap: () {
                // Buka layar peta fullscreen dengan sliding panel
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => FullMapScreen(
                          centerLocation: _centerLocation,
                          driverLocation: _driverLocation,
                        )));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    IgnorePointer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: _centerLocation,
                            initialZoom: 14.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.example.flutter_responsi_1',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _centerLocation,
                                  width: 60,
                                  height: 60,
                                  child: const Icon(Icons.location_on,
                                      color: Colors.red, size: 36),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Estimated time badge (top-right)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 6),
                          ],
                        ),
                        child: const Text('Estimated Time\n5-10 min',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    // Small label centered near top
                    Positioned(
                      top: 40,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Seven Wonder\'s Park, Kota',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),

                    // View larger hint at bottom center
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                          child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text('View larger map',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      )),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Timeline Status Pesanan
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: const [
                    Text(
                      "Order Status",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _StatusTile(
                        isDone: true,
                        title: 'Order Received',
                        time: '12:10pm',
                        isLast: false),
                    _StatusTile(
                        isDone: true,
                        title: 'Order Confirmed',
                        time: '12:15pm',
                        isLast: false),
                    _StatusTile(
                        isDone: true,
                        title: 'On Delivery',
                        time: '12:20pm',
                        isLast: true),
                  ],
                ),
              ),
            ),

            // 🔹 Tombol Confirm
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/orders');
                },
                child: const Text("CONFIRM DELIVERY",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullMapScreen extends StatefulWidget {
  final LatLng centerLocation;
  final LatLng driverLocation;

  const FullMapScreen(
      {super.key, required this.centerLocation, required this.driverLocation});

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Track Order', style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          SlidingUpPanel(
            controller: _panelController,
            minHeight: 110,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            panelBuilder: (ScrollController sc) => _buildPanel(sc),
            body: FlutterMap(
              options: MapOptions(
                initialCenter: widget.centerLocation,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.flutter_responsi_1',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.centerLocation,
                      width: 80,
                      height: 80,
                      child: const Icon(Icons.location_on,
                          color: Colors.red, size: 40),
                    ),
                    Marker(
                      point: widget.driverLocation,
                      width: 80,
                      height: 80,
                      child: const Icon(Icons.directions_car,
                          color: Colors.blueAccent, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // overlay contact card ABOVE the panel so it is not covered
          Positioned(
            bottom: 90,
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => _panelController.open(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5))
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            AssetImage('assets/images/james_profile.jpg')),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Erick Khan',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          SizedBox(height: 4),
                          Text('ID 2445556',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.call,
                              size: 18, color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white24,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.chat,
                              size: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel(ScrollController sc) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 6),
          Expanded(
            child: ListView(
              controller: sc,
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Order Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const _StatusTile(isDone: true, title: 'Order Received', time: '12:10pm', isLast: false),
                const _StatusTile(isDone: true, title: 'Order Confirmed', time: '12:15pm', isLast: false),
                const _StatusTile(isDone: true, title: 'On Delivery', time: '12:20pm', isLast: true),
                const SizedBox(height: 20),
                const SizedBox(height: 8),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/orders');
                        },
                        child: const Text('CONFIRM DELIVERY', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk status timeline
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
              Container(width: 2, height: 30, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight:
                          isDone ? FontWeight.bold : FontWeight.normal)),
              Text(time,
                  style: const TextStyle(color: Colors.black54, fontSize: 12)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
