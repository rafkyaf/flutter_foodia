import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool hasBottomNav;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final PreferredSizeWidget? appBar;

  const BaseScreen({
    super.key,
    required this.child,
    this.backgroundColor,
    this.hasBottomNav = false,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: SafeArea(
        bottom: !hasBottomNav,
        child: Stack(
          children: [
            child,
            // Add extra bottom padding when there's a bottom nav
            if (hasBottomNav)
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
      bottomNavigationBar: bottomNavigationBar != null
          ? SafeArea(
              child: bottomNavigationBar!,
            )
          : null,
    );
  }
}