import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/constants/currency_format.dart';
import 'package:rosantibike_mobile/constants/snackbar_utils.dart';
import 'package:shimmer/shimmer.dart';
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

  // Adjusted height calculations for better responsiveness
  double _getResponsiveHeight(Size size) {
    // Use shorter heights to prevent overflow
    if (size.width <= 360) return size.height * 0.22;
    if (size.width <= 600) return size.height * 0.25;
    if (size.width <= 900) return size.height * 0.28;
    return size.height * 0.32;
  }

  double _getResponsiveViewportFraction(double width) {
    if (width <= 360) return 0.8;
    if (width <= 600) return 0.85;
    return 0.88;
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
          SnackBarHelper.showErrorSnackBar(
            context,
            'Mencoba menyambungkan kembali',
          );
        }
      },
      builder: (context, state) {
        if (state is DashboardLoading) {
          return _buildShimmerLoading(carouselHeight, theme, size);
        }

        if (state is DashboardLoaded) {
          if (state.motorUnits.isEmpty) {
            return _buildEmptyState(carouselHeight, theme);
          }

          return _buildCarousel(state, carouselHeight, isDarkMode, theme, size);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmerLoading(double height, ThemeData theme, Size size) {
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider.builder(
              itemCount: 3,
              options: CarouselOptions(
                viewportFraction: _getResponsiveViewportFraction(size.width),
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
              itemBuilder: (context, index, _) {
                return Shimmer.fromColors(
                  baseColor: theme.brightness == Brightness.dark
                      ? Colors.grey[800]!
                      : Colors.grey[300]!,
                  highlightColor: theme.brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[100]!,
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8), // Reduced spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: theme.primaryColor.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double height, ThemeData theme) {
    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.motorcycle_outlined,
              size: 48,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              "No motor units available",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(DashboardLoaded state, double height, bool isDarkMode,
      ThemeData theme, Size size) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Added to prevent overflow
        children: [
          Expanded(
            child: CarouselSlider.builder(
              carouselController: _controller,
              itemCount: state.motorUnits.length,
              options: CarouselOptions(
                viewportFraction: _getResponsiveViewportFraction(size.width),
                enlargeCenterPage: true,
                autoPlay: state.motorUnits.length > 1,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
          if (state.motorUnits.length > 1) ...[
            const SizedBox(height: 8), // Reduced spacing
            SizedBox(
              height: 8, // Fixed height for indicators
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  state.motorUnits.length,
                  (index) => Container(
                    width: _currentIndex == index ? 16 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: theme.primaryColor
                          .withOpacity(_currentIndex == index ? 1 : 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
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

    final formattedPrice = formatCurrency(hargaPerHari);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.1),
          width: 20,
        ),
      ),
      elevation: isDarkMode ? 2 : 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'motor_${unit['id']}',
                    child: foto.isNotEmpty
                        ? Image.network(
                            foto,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const _ErrorImage(),
                            loadingBuilder: (_, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return _LoadingImage(
                                  loadingProgress: loadingProgress);
                            },
                          )
                        : const _ErrorImage(),
                  ),
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
                vertical: isSmallScreen ? 6 : 8, // Reduced vertical padding
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Added to prevent overflow
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    merk,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 14 : 16, // Responsive font size
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // Reduced spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$formattedPrice / Hari',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize:
                              isSmallScreen ? 12 : 14, // Responsive font size
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: isSmallScreen ? 16 : 20,
                        color: theme.primaryColor,
                      ),
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
    final isReady = status.toLowerCase() == 'ready';
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12,
        vertical: isSmallScreen ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: isReady
            ? Colors.green.withOpacity(0.9)
            : Colors.orange.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isReady ? Colors.green : Colors.orange).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isReady ? Icons.check_circle : Icons.access_time_rounded,
            size: isSmallScreen ? 12 : 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isSmallScreen ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorImage extends StatelessWidget {
  const _ErrorImage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;

    return Container(
      color: theme.brightness == Brightness.dark
          ? Colors.grey[850]
          : Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: isSmallScreen ? 32 : 40,
              color: theme.brightness == Brightness.dark
                  ? Colors.grey[700]
                  : Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? Colors.grey[600]
                    : Colors.grey[500],
                fontSize: isSmallScreen ? 10 : 12,
              ),
            ),
          ],
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
    final theme = Theme.of(context);

    return Container(
      color: theme.brightness == Brightness.dark
          ? Colors.grey[850]
          : Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          strokeWidth: 2, // Thinner stroke for better appearance
        ),
      ),
    );
  }
}
