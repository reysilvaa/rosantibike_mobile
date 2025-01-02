import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';

class MotorCarousel extends StatefulWidget {
  const MotorCarousel({Key? key}) : super(key: key);

  @override
  State<MotorCarousel> createState() => _MotorCarouselState();
}

class _MotorCarouselState extends State<MotorCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  final List<Map<String, dynamic>> _motorUnits = [
    {
      'name': 'Honda CBR 250RR',
      'image': 'assets/cbr.jpg',
      'price': 'Rp 75.000.000',
      'status': 'Available',
      'specs': ['250cc', 'Sport', '2023'],
    },
    {
      'name': 'Yamaha R15',
      'image': 'assets/r15.jpg',
      'price': 'Rp 39.000.000',
      'status': 'Limited',
      'specs': ['155cc', 'Sport', '2023'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // Responsive height calculations
    double getResponsiveHeight() {
      if (size.width <= 600) return size.height * 0.25;
      if (size.width <= 900) return size.height * 0.3;
      return size.height * 0.35;
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: getResponsiveHeight(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CarouselSlider.builder(
              carouselController: _controller,
              itemCount: _motorUnits.length,
              options: CarouselOptions(
                viewportFraction: size.width > 400
                    ? 0.85
                    : 0.5, // Mengurangi nilai viewportFraction untuk jarak antar item
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  setState(() => _currentIndex = index);
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal:
                          1), // Menambahkan padding agar ada jarak antar item
                  child: MotorCard(
                    unit: _motorUnits[index],
                    isDarkMode: isDarkMode,
                    theme: theme,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _motorUnits.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor.withOpacity(
                      _currentIndex == entry.key ? 1 : 0.4,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class MotorCard extends StatelessWidget {
  final Map<String, dynamic> unit;
  final bool isDarkMode;
  final ThemeData theme;

  const MotorCard({
    Key? key,
    required this.unit,
    required this.isDarkMode,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width <= 600;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF1E1E1E),
                  const Color(0xFF2C2C2C),
                ]
              : [
                  Colors.white,
                  Colors.grey.shade50,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(isDarkMode ? 0.2 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                unit['image'],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unit['name'],
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unit['price'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            _buildSpecChip(
                                unit['specs'][0], theme, isSmallScreen),
                            const SizedBox(width: 4),
                            if (!isSmallScreen) ...[
                              _buildSpecChip(
                                  unit['specs'][1], theme, isSmallScreen),
                              const SizedBox(width: 4),
                            ],
                          ],
                        ),
                      ),
                      _buildStatusBadge(unit['status'], theme, isSmallScreen),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecChip(String text, ThemeData theme, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 6 : 8,
        vertical: isSmallScreen ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.primaryColor,
          fontSize: isSmallScreen ? 10 : 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, ThemeData theme, bool isSmallScreen) {
    final isAvailable = status.toLowerCase() == 'available';
    final color = isAvailable ? Colors.green : Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 6 : 8,
        vertical: isSmallScreen ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontSize: isSmallScreen ? 10 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
