import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool _hasNavigated = false;

  // Loading and entrance effect states
  bool _isLoading = false;
  bool _showEntranceEffect = false;
  final Duration _effectDuration = const Duration(milliseconds: 700);

  // Intro animations
  late final AnimationController _introController;
  late final Animation<double> _iconScale;
  late final Animation<double> _iconShadow;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _titleOpacity;
  late final AnimationController _dotsController;
  late final AnimationController _bgController;
  // Minimal mode matches the provided image: centered icon + title, no controls
  final bool _minimalSplash = true;

  @override
  void initState() {
    super.initState();

    // primary and backup timers to ensure navigation proceeds
    Timer(const Duration(seconds: 3), () {
      _maybeNavigate();
    });

    Timer(const Duration(seconds: 6), () {
      _maybeNavigate();
    });

    // setup intro animations
    _introController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _iconScale = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _introController, curve: Curves.elasticOut));
    _titleOffset = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _introController, curve: Curves.easeOut));
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _introController, curve: const Interval(0.4, 1.0, curve: Curves.easeIn)));

    // small shadow/pulse under the icon to add depth
    _iconShadow = Tween<double>(begin: 0.0, end: 14.0).animate(CurvedAnimation(parent: _introController, curve: Curves.easeOut));

    _dotsController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _dotsController.repeat(reverse: true);

    // background motion
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _bgController.repeat();

    // auto-navigate shortly after the intro finishes
    _introController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          _maybeNavigate();
        });
      }
    });

    // start the intro
    _introController.forward();
  }

  Future<void> _startLoadingAndNavigate() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    // small delay to show button spinner, then launch entrance effect
    await Future.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;

    setState(() {
      _showEntranceEffect = true;
    });

    // wait for the entrance animation to finish, then navigate
    await Future.delayed(_effectDuration + const Duration(milliseconds: 120));
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _introController.dispose();
    _dotsController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  void _maybeNavigate() {
    if (_hasNavigated) return;
    if (!mounted) return;
    _hasNavigated = true;

    try {
      Navigator.pushReplacementNamed(context, '/carousel');
    } catch (e) {
      debugPrint('[Splash] navigation to /carousel failed: $e');
      try {
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e2) {
        debugPrint('[Splash] fallback navigation failed: $e2');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeBlue = const Color(0xFF2B56A0);
    final accent = const Color(0xFF50B6FF);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
                      // Animated moving background (gradient + decorative circles) - render first so other content sits on top
            AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                final size = MediaQuery.of(context).size;
                final t = _bgController.value;

                final x1 = (size.width * 0.62) + 40 * sin(2 * pi * t);
                final y1 = -size.height * 0.12 + 50 * cos(2 * pi * t);

                final x2 = -size.width * 0.18 + 60 * cos(2 * pi * (t + 0.23));
                final y2 = size.height * 0.6 + 30 * sin(2 * pi * (t + 0.23));

                final x3 = size.width * 0.08 + 30 * sin(2 * pi * (t + 0.6));
                final y3 = size.height * 0.34 + 40 * cos(2 * pi * (t + 0.6));

                return Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF263B66), Color(0xFF1F3357)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: Stack(
                      children: [
                        Positioned(left: x1, top: y1, child: Container(width: 260, height: 260, decoration: const BoxDecoration(color: Color.fromRGBO(255,255,255,0.03), shape: BoxShape.circle))),
                        Positioned(left: x2, top: y2, child: Container(width: 160, height: 160, decoration: const BoxDecoration(color: Color.fromRGBO(255,255,255,0.02), shape: BoxShape.circle))),
                        Positioned(left: x3, top: y3, child: Container(width: 56, height: 56, decoration: const BoxDecoration(color: Color.fromRGBO(255,255,255,0.03), shape: BoxShape.circle))),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Center content over animated background (full-screen blue look)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _iconScale,
                    child: AnimatedBuilder(
                      animation: _iconShadow,
                      builder: (context, child) {
                        return Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(80,182,255,0.12),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.18),
                                blurRadius: _iconShadow.value,
                                offset: Offset(0, _iconShadow.value / 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/logofoodia1.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stack) {
                                    debugPrint('[Splash] logo asset load error: $error');
                                    return Container(
                                      color: accent,
                                      child: const Center(child: Icon(Icons.restaurant_menu, color: Colors.white, size: 30)),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // animated dots (hidden in minimal mode)
                  if (!_minimalSplash)
                    AnimatedBuilder(
                      animation: _dotsController,
                      builder: (context, child) {
                        final double t = _dotsController.value; // 0..1
                        final double scale = 1.0 + 0.18 * t;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.scale(
                              scale: scale,
                              child: Container(width: 8, height: 8, decoration: BoxDecoration(color: const Color.fromRGBO(255,255,255,0.95), borderRadius: BorderRadius.circular(8))),
                            ),
                            const SizedBox(width: 8),
                            Transform.scale(
                              scale: 1.0 + 0.06 * (1 - t),
                              child: Container(width: 8, height: 8, decoration: BoxDecoration(color: const Color.fromRGBO(255,255,255,0.28), borderRadius: BorderRadius.circular(8))),
                            ),
                            const SizedBox(width: 8),
                            Transform.scale(
                              scale: 1.0 + 0.03 * t,
                              child: Container(width: 8, height: 8, decoration: BoxDecoration(color: const Color.fromRGBO(255,255,255,0.18), borderRadius: BorderRadius.circular(8))),
                            ),
                          ],
                        );
                      },
                    ),

                  const SizedBox(height: 18),

                  SlideTransition(
                    position: _titleOffset,
                    child: FadeTransition(
                      opacity: _titleOpacity,
                      child: const Text('Foodia', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // subtitle hidden in minimal mode
                  if (!_minimalSplash)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        'Fresh & Fast Delivery',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, color: Color.fromRGBO(255,255,255,0.9)),
                      ),
                    ),
                ],
              ),
            ),

            // bottom centered LET'S ROCK button (hidden in minimal mode)
            if (!_minimalSplash)
              Positioned(
                left: 24,
                right: 24,
                bottom: 36,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _startLoadingAndNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 8,
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: accent)),
                            const SizedBox(width: 12),
                            Text('Loading...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: accent)),
                          ],
                        )
                      : Text("LET'S ROCK", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: themeBlue)),
                ),
              ),

            // Entrance effect overlay (fullscreen, blue card style) when triggered - on top of everything
            if (_showEntranceEffect)
              Positioned.fill(
                child: AnimatedContainer(
                  duration: _effectDuration,
                  curve: Curves.easeOutCubic,
                  color: themeBlue,
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.6, end: 1.0),
                      duration: _effectDuration,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: scale.clamp(0.0, 1.0),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(80,182,255,0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(color: const Color(0xFF50B6FF), borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 36),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text('Foodia', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        ],
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
