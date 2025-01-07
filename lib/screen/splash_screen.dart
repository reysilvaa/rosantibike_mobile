import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rosantibike_mobile/pages/auth/login_page.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';

import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const SplashScreen({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class ThemeToggleButton extends StatelessWidget {
  final ThemeProvider themeProvider;

  const ThemeToggleButton({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            themeProvider.isDarkMode
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            key: ValueKey<bool>(themeProvider.isDarkMode),
            color: Theme.of(context).primaryColor,
          ),
        ),
        onPressed: () {
          themeProvider.toggleTheme();
        },
      ),
    );
  }
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _scaleController;
  late AnimationController _widthController;
  late AnimationController _positionController;
  late AnimationController _scale2Controller;

  late Animation<double> _scaleAnimation;
  late Animation<double> _widthAnimation;
  late Animation<double> _positionAnimation;
  late Animation<double> _scale2Animation;

  bool hideIcon = false;
  int _currentPage = 0;
  final List<FeatureItem> features = [
    FeatureItem(
      icon: Icons.speed_rounded,
      title: 'Pemesanan Cepat',
      description:
          'Pesan perjalanan Anda dalam hitungan detik dengan proses yang efisien',
    ),
    FeatureItem(
      icon: Icons.location_on_rounded,
      title: 'Pelacakan Real-time',
      description: 'Ketahui dengan tepat di mana perjalanan Anda setiap saat',
    ),
    FeatureItem(
      icon: Icons.safety_check_rounded,
      title: 'Aman & Terjamin',
      description:
          'Keamanan data Anda adalah prioritas utama saya jadi jangan khawatir',
    ),
    FeatureItem(
      icon: Icons.support_agent_rounded,
      title: 'Dukungan 24/7',
      description:
          'Layanan dukungan yang mudah sepanjang waktu siap melayani Anda',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.9,
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_scaleController);

    _widthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _widthAnimation =
        Tween<double>(begin: 80.0, end: 300.0).animate(_widthController);

    _positionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _positionAnimation =
        Tween<double>(begin: 0.0, end: 215.0).animate(_positionController);

    _scale2Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scale2Animation =
        Tween<double>(begin: 1.0, end: 32.0).animate(_scale2Controller);

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });

    _setupAnimationListeners();
  }

  void _setupAnimationListeners() {
    _scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _widthController.forward();
      }
    });

    _widthController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _positionController.forward();
      }
    });

    _positionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          hideIcon = true;
        });
        _scale2Controller.forward();
      }
    });

    _scale2Controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextPage();
      }
    });
  }

  void _navigateToNextPage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            token == null ? LoginPage() : MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            // Top Gradient
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.primaryColor.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Theme Toggle Button
            Positioned(
              top: 50,
              right: 20,
              child: FadeAnimation(
                duration: const Duration(milliseconds: 1000),
                child: ThemeToggleButton(
                  themeProvider: widget.themeProvider,
                ),
              ),
            ),

            // Welcome Text
            Positioned(
              top: 60,
              left: 20,
              right: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeAnimation(
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      "Selamat Datang",
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),
                  SizedBox(height: 15),
                  FadeAnimation(
                    duration: const Duration(milliseconds: 1300),
                    child: Text(
                      "dalam hadir kemudahan akses\nPengelola Rosantibike Motorent.",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Features PageView
            Positioned(
              top: 220,
              left: 0,
              right: 0,
              height: 400,
              child: PageView.builder(
                controller: _pageController,
                itemCount: features.length,
                itemBuilder: (context, index) {
                  return FadeAnimation(
                    duration: Duration(milliseconds: 1000 + (index * 100)),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            features[index].icon,
                            size: 80,
                            color: theme.primaryColor,
                          ),
                          SizedBox(height: 30),
                          Text(
                            features[index].title,
                            style: theme.textTheme.titleLarge,
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              features[index].description,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Page Indicator
            Positioned(
              bottom: 160,
              left: 0,
              right: 0,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  features.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? theme.primaryColor
                          : theme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),

            // Start Button
            Positioned(
              bottom: 60,
              left: 20,
              right: 20,
              child: FadeAnimation(
                duration: const Duration(milliseconds: 1600),
                child: _buildStartButton(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(ThemeData theme) {
    return AnimatedBuilder(
      animation: _scaleController,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Center(
          child: AnimatedBuilder(
            animation: _widthController,
            builder: (context, child) => Container(
              width: _widthAnimation.value,
              height: 80,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: theme.primaryColor.withOpacity(.4),
              ),
              child: InkWell(
                onTap: () {
                  _scaleController.forward();
                },
                child: Stack(
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _positionController,
                      builder: (context, child) => Positioned(
                        left: _positionAnimation.value,
                        child: AnimatedBuilder(
                          animation: _scale2Controller,
                          builder: (context, child) => Transform.scale(
                            scale: _scale2Animation.value,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.primaryColor,
                              ),
                              child: hideIcon == false
                                  ? Icon(
                                      Icons.arrow_forward,
                                      color: theme.colorScheme.onPrimary,
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scaleController.dispose();
    _widthController.dispose();
    _positionController.dispose();
    _scale2Controller.dispose();
    super.dispose();
  }
}

class FadeAnimation extends StatelessWidget {
  final Duration duration;
  final Widget child;

  FadeAnimation({required this.duration, required this.child});

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, animationValue, child) {
        return Opacity(
          opacity: animationValue,
          child: Transform.translate(
            offset: Offset(0, (1 - animationValue) * -30),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
