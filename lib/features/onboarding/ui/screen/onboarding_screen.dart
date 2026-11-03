
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../shared/providers/app_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;
  Timer? _autoSlideTimer;

  final List<_OnboardingData> _pages = [
    const _OnboardingData(
      title: 'Welcome to Terminal 1',
      description:
      'Your gateway to global crypto markets. Explore, analyze, and trade with powerful market tools.',
      icon: Icons.currency_exchange_rounded,
    ),
    const _OnboardingData(
      title: 'Trade Global Crypto Markets',
      description:
      'Access real-time prices, advanced charts, and powerful trading tools anywhere.',
      icon: Icons.show_chart_rounded,
    ),
    const _OnboardingData(
      title: 'Track Your Portfolio & Performance',
      description:
      'Your Portfolio, At a Glance\n\nTrack your PnL and stay on top of your trading performance.',
      icon: Icons.account_balance_wallet_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();

    _autoSlideTimer = Timer.periodic(
      const Duration(seconds: 4),
          (timer) {
        if (!_pageController.hasClients) return;

        final nextPage = (_currentPage + 1) % _pages.length;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _skip() async{
    _autoSlideTimer?.cancel();
    await ref.read(localStorageProvider).setOnboardingSeen();

    if (!mounted) return;
    context.goNamed(RouteNames.homeName);
  }

  void _signUp() async{
    _autoSlideTimer?.cancel();
    await ref.read(localStorageProvider).setOnboardingSeen();

    if (!mounted) return;
    context.pushNamed(RouteNames.registerName);
  }

  void _login()async {
    _autoSlideTimer?.cancel();
    await ref.read(localStorageProvider).setOnboardingSeen();

    if (!mounted) return;
    context.pushNamed(RouteNames.signInName);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? const Color(0xFF050B19)
        : const Color(0xFFF3F7FF);

    final textColor =
    isDark ? Colors.white : const Color(0xFF101C35);

    final secondaryText =
    isDark ? Colors.white70 : const Color(0xFF596981);

    final surfaceColor =
    isDark ? const Color(0xFF17243B) : Colors.white;

    const primaryBlue = Colors.blue;

    return Scaffold(
      backgroundColor: background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
              Color(0xFF101A39),
              Color(0xFF080E20),
              Color(0xFF050B19),
            ]
                : const [
              Color(0xFFE5EEFF),
              Color(0xFFF4F7FF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Skip button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _skip,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Onboarding pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          const Spacer(flex: 3),

                          // Illustration
                          Expanded(
                            flex: 11,
                            child: Center(
                              child: index == 1
                                  ? _CryptoChartIllustration(
                                isDark: isDark,
                              )
                                  : _FeatureIllustration(
                                icon: page.icon,
                                isDark: isDark,
                              ),
                            ),
                          ),

                          const Spacer(flex: 2),

                          // Title
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 23,
                              height: 1.18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.6,
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Description
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Text(
                              page.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),

                          const Spacer(flex: 3),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) {
                    final selected = _currentPage == index;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 8,
                      width: selected ? 17 : 8,
                      decoration: BoxDecoration(
                        color: selected
                            ? primaryBlue
                            : (isDark
                            ? Colors.white24
                            : const Color(0xFFB8CCE9)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Sign Up and Login buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _login,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: surfaceColor,
                            side: BorderSide(
                              color: isDark
                                  ? Colors.blue.withValues(alpha: 0.25)
                                  : const Color(0xFFD5E3FA),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Onboarding data
class _OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  const _OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

// Crypto chart illustration
class _CryptoChartIllustration extends StatelessWidget {
  final bool isDark;

  const _CryptoChartIllustration({
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 360),
      height: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
            Color(0xFF102447),
            Color(0xFF101A35),
            Color(0xFF080F21),
          ]
              : const [
            Color(0xFFDCE9FF),
            Color(0xFFEDF4FF),
            Colors.white,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _ChartPainter(isDark: isDark),
            ),
          ),

          Positioned(
            top: 16,
            left: 18,
            right: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1B2B46)
                    : Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.18 : 0.06,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFFF7931A),
                    child: Icon(
                      Icons.currency_bitcoin,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Text(
                    'BTC/USDT',
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF202438),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '+2.84%',
                    style: TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Candlestick chart painter
class _ChartPainter extends CustomPainter {
  final bool isDark;

  _ChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = isDark
          ? Colors.blue.withValues(alpha: 0.12)
          : const Color(0xFF3978D6).withValues(alpha: 0.10)
      ..strokeWidth = 0.7;

    for (int i = 0; i <= 5; i++) {
      final y = size.height * 0.32 + i * 27.0;

      canvas.drawLine(
        Offset(12, y),
        Offset(size.width - 12, y),
        gridPaint,
      );
    }

    for (int i = 0; i <= 7; i++) {
      final x = 20.0 + i * 43.0;

      canvas.drawLine(
        Offset(x, size.height * 0.30),
        Offset(x, size.height - 12),
        gridPaint,
      );
    }

    final candles = [
      [0.72, 0.57, 0.78, 0.48],
      [0.63, 0.48, 0.69, 0.40],
      [0.51, 0.42, 0.57, 0.34],
      [0.38, 0.52, 0.60, 0.35],
      [0.54, 0.61, 0.67, 0.49],
      [0.62, 0.52, 0.68, 0.45],
      [0.53, 0.39, 0.58, 0.31],
      [0.40, 0.30, 0.47, 0.23],
    ];

    const candleWidth = 11.0;
    const startX = 24.0;
    final gap = (size.width - 60) / 7;

    for (int i = 0; i < candles.length; i++) {
      final candle = candles[i];
      final x = startX + i * gap;

      final open = size.height * candle[0];
      final close = size.height * candle[1];
      final high = size.height * candle[2];
      final low = size.height * candle[3];

      final bullish = close < open;

      final color = bullish
          ? const Color(0xFF2196F3)
          : const Color(0xFF526FE5);

      final paint = Paint()
        ..color = color
        ..strokeWidth = 1.5;

      canvas.drawLine(
        Offset(x + candleWidth / 2, high),
        Offset(x + candleWidth / 2, low),
        paint,
      );

      final top = math.min(open, close);
      final bottom = math.max(open, close);

      canvas.drawRect(
        Rect.fromLTRB(
          x,
          top,
          x + candleWidth,
          math.max(bottom, top + 5),
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

// Welcome and notification illustrations
class _FeatureIllustration extends StatelessWidget {
  final IconData icon;
  final bool isDark;

  const _FeatureIllustration({
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: isDark
              ? const [
            Color(0xFF164D9C),
            Color(0xFF102447),
            Color(0x00080F21),
          ]
              : const [
            Color(0xFFBBD7FF),
            Color(0xFFE0ECFF),
            Color(0x00FFFFFF),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF64B5F6),
                Color(0xFF1976D2),
                Color(0xFF0D47A1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.35),
                blurRadius: 35,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 68,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
