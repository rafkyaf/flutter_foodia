import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Library Peta Gratis (OSM)
import 'package:latlong2/latlong.dart'; // Helper untuk koordinat
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
    // Menghitung tinggi peta agar responsif
    final double mapHeight = MediaQuery.of(context).size.height * 0.45;

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

            // 🔹 AREA PETA (OPEN STREET MAP)
            // Menggunakan FlutterMap, bukan GoogleMap
            SizedBox(
              height: mapHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: _centerLocation, // Titik tengah peta
                      initialZoom: 15.0, // Level zoom
                    ),
                    children: [
                      // Layer Peta (Gambar Peta dari Server Gratis OSM)
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'com.example.flutter_responsi_1', // Identitas aplikasi (opsional tapi disarankan)
                      ),

                      // Layer Marker (Pin Merah & Driver)
                      MarkerLayer(
                        markers: [
                          // Marker Tujuan (Merah)
                          Marker(
                            point: _centerLocation,
                            width: 80,
                            height: 80,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                          // Marker Driver (Biru / Mobil)
                          Marker(
                            point: _driverLocation,
                            width: 80,
                            height: 80,
                            child: const Icon(
                              Icons.directions_car,
                              color: Colors.blueAccent,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Kartu Info Driver (Floating di atas peta)
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundImage:
                                AssetImage('assets/images/james_profile.jpg'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Erick Khan',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text('ID 2445556',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12)),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blueAccent,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.call,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                  Navigator.pushReplacementNamed(context, '/product');
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
