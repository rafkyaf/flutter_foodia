import 'package:flutter/material.dart';

class BottomNavScreen extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const BottomNavScreen({
    super.key,
    required this.body,
    required this.bottomNavigationBar,
    this.backgroundColor,
    this.drawer,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: drawer,
      appBar: appBar,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            body,
            // Add bottom padding for notched devices
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).padding.bottom,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: SafeArea(
        child: bottomNavigationBar,
      ),
    );
  }
}