import 'package:flutter/material.dart';

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({super.key});

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    'assets/images/shop foodia.png',
    'assets/images/truck foodia.png',
    'assets/images/delivery.png',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),

            // 🔹 BAGIAN GAMBAR CAROUSEL
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Image.asset(
                      _images[index],
                      width: size.width * 0.85,
                      height: size.height * 0.45,
                      fit: BoxFit.contain, // menjaga ketajaman logo/gambar
                      filterQuality:
                          FilterQuality.high, // menampilkan gambar lebih tajam
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 TITIK INDIKATOR — bisa diklik
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _images.length,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                    setState(() => _currentPage = index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: _currentPage == index ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔹 TEKS FOODIA
            const Text(
              "Foodia",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 TEKS DESKRIPSI
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blueAccent,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 35),

            // 🔹 TOMBOL "LET'S ROCK"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                "LET'S ROCK",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
