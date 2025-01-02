import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_bloc.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_state.dart';

class MotorCarousel extends StatefulWidget {
  const MotorCarousel({Key? key}) : super(key: key);

  @override
  State<MotorCarousel> createState() => _MotorCarouselState();
}

class _MotorCarouselState extends State<MotorCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  double _getResponsiveHeight(Size size) {
    if (size.width <= 600) return size.height * 0.28;
    if (size.width <= 900) return size.height * 0.32;
    return size.height * 0.35;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final carouselHeight = _getResponsiveHeight(size);

    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is DashboardLoading) {
          return SizedBox(
            height: carouselHeight,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is DashboardLoaded) {
          if (state.motorUnits.isEmpty) {
            return SizedBox(
              height: carouselHeight,
              child: Center(
                child: Text(
                  "No motor units available",
                  style: theme.textTheme.titleMedium,
                ),
              ),
            );
          }

          return SizedBox(
            height: carouselHeight,
            child: Column(
              children: [
                Expanded(
                  child: CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: state.motorUnits.length,
                    options: CarouselOptions(
                      viewportFraction: size.width > 400 ? 0.85 : 0.8,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (index, _) =>
                          setState(() => _currentIndex = index),
                    ),
                    itemBuilder: (context, index, _) {
                      return MotorCard(
                        unit: state.motorUnits[index],
                        isDarkMode: isDarkMode,
                        theme: theme,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.motorUnits.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentIndex == index ? 16 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: theme.primaryColor.withOpacity(
                          _currentIndex == index ? 1 : 0.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class MotorCard extends StatelessWidget {
  final dynamic unit;
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

    final stok = unit['stok'] ?? {};
    final merk = stok['merk'] ?? 'Unknown';
    final foto = stok['foto'] ?? '';
    final hargaPerHari = stok['harga_perHari'] ?? '0';
    final status = unit['status'] ?? 'Unknown';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      elevation: isDarkMode ? 2 : 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (foto.isNotEmpty)
                    Image.network(
                      foto,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _ErrorImage(),
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _LoadingImage(loadingProgress: loadingProgress);
                      },
                    )
                  else
                    const _ErrorImage(),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _StatusBadge(status: status, theme: theme),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 8 : 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    merk,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp $hargaPerHari / day',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
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

class _StatusBadge extends StatelessWidget {
  final String status;
  final ThemeData theme;

  const _StatusBadge({
    required this.status,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.toLowerCase() == 'ready'
            ? Colors.green.withOpacity(0.9)
            : Colors.orange.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ErrorImage extends StatelessWidget {
  const _ErrorImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _LoadingImage extends StatelessWidget {
  final ImageChunkEvent loadingProgress;

  const _LoadingImage({required this.loadingProgress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  }
}
