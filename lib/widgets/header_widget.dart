import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return _buildHeader(context, themeProvider);
  }

  final String title;

  const HeaderWidget({Key? key, required this.title}) : super(key: key);

  @override

  // Custom header dengan penyesuaian warna background dan teks
  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22, // Ukuran teks tetap besar untuk visibilitas
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black, // Sesuaikan warna teks berdasarkan mode
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: theme.iconTheme.color,
              ),
              onPressed: () => themeProvider.toggleTheme(),
            ),
            IconButton(
              icon: Icon(Icons.more_horiz, color: theme.iconTheme.color),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
