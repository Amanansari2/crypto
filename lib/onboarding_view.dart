import 'package:crypto_app/animated_wrapper.dart';
import 'package:crypto_app/home_view.dart';
import 'package:crypto_app/providers/theme_provider.dart';
import 'package:crypto_app/utils/enums/app_theme_type.dart';
import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key, });

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final List<Color> _featuresColor = [
    CupertinoColors.systemBlue,
    CupertinoColors.systemGreen,
    CupertinoColors.systemOrange,
    CupertinoColors.systemPurple,
    CupertinoColors.systemTeal,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            ref.read(themeProvider.notifier).toggleTheme();
          },
          icon: Icon(
              ref.watch(themeProvider) == AppThemeType.dark
        ? Icons.light_mode
        : Icons.dark_mode,
          ),
        ),
      ),

      body: CupertinoOnboarding(
        bottomButtonColor: CupertinoColors.activeBlue,
        bottomButtonChild: Text('Continue'),
        onPressedOnLastPage: () {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => HomeView()),
          );
        },
        pages: [
          _buildFirstPage(),
          _buildSecondPage(),
          _buildThirdPage(),
          _buildForthPage(),
        ],
      ),
    );
  }

  _buildFirstPage() {
    return WhatsNewPage(
      titleFlex: 5,
      title: AnimatedWrapper(index: 0, child: Text('Select you car')),
      features: [
        AnimatedWrapper(
          index: 1,
          child: WhatsNewFeature(
            title: Text('Wide raange of cars'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 0),
          ),
        ),
        AnimatedWrapper(
          index: 2,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.creditcard, 1),
          ),
        ),
        AnimatedWrapper(
          index: 3,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 2),
          ),
        ),
        AnimatedWrapper(
          index: 4,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 2),
          ),
        ),
      ],
    );
  }

  _buildSecondPage() {
    return WhatsNewPage(
      titleFlex: 3,
      title: AnimatedWrapper(index: 0, child: Text('Select you car')),
      features: [
        AnimatedWrapper(
          index: 1,
          child: WhatsNewFeature(
            title: Text('Wide raange of cars'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 0),
          ),
        ),
        AnimatedWrapper(
          index: 2,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.creditcard, 1),
          ),
        ),
        AnimatedWrapper(
          index: 3,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 2),
          ),
        ),
        AnimatedWrapper(
          index: 4,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 2),
          ),
        ),
      ],
    );
  }

  _buildThirdPage() {
    return WhatsNewPage(
      titleFlex: 5,
      title: AnimatedWrapper(index: 0, child: Text('Select you car')),
      features: [
        AnimatedWrapper(
          index: 1,
          child: WhatsNewFeature(
            title: Text('Wide raange of cars'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 0),
          ),
        ),
        AnimatedWrapper(
          index: 2,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.creditcard, 1),
          ),
        ),
        AnimatedWrapper(
          index: 3,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 2),
          ),
        ),
        AnimatedWrapper(
          index: 4,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 2),
          ),
        ),
      ],
    );
  }

  _buildForthPage() {
    return WhatsNewPage(
      titleFlex: 5,
      title: AnimatedWrapper(index: 0, child: Text('Select you car')),
      features: [
        AnimatedWrapper(
          index: 1,
          child: WhatsNewFeature(
            title: Text('Wide raange of cars'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 0),
          ),
        ),
        AnimatedWrapper(
          index: 2,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.creditcard, 1),
          ),
        ),
        AnimatedWrapper(
          index: 3,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 2),
          ),
        ),
        AnimatedWrapper(
          index: 4,
          child: WhatsNewFeature(
            title: Text('Wide range of crypto currencies'),
            description: Text(
              'We offer a wide range of crypto currencies to choose from',
            ),
            icon: _coloredIcon(CupertinoIcons.car_detailed, 2),
          ),
        ),
      ],
    );
  }

  Icon _coloredIcon(IconData icon, int index) {
    return Icon(
      icon,
      color: _featuresColor[index % _featuresColor.length],
      size: 28,
    );
  }
}
