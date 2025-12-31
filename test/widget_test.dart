import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_foodia/main.dart';

void main() {
  testWidgets('App loads main screen', (WidgetTester tester) async {
    // Build aplikasi utama
    await tester.pumpWidget(const MyApp());

    // Pastikan ada teks atau widget tertentu di layar utama
    expect(find.text('Payment'), findsOneWidget); // Ganti sesuai tampilan awalmu
  });
}
