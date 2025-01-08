import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class HeaderWidget extends StatelessWidget {
  final String title;

  const HeaderWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              _buildThemeToggle(context, theme),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: theme.iconTheme.color,
                ),
                onPressed: () => _showThemeMenu(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, ThemeData theme) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) => IconButton(
        icon: Icon(
          themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: theme.iconTheme.color,
        ),
        onPressed: () => themeProvider.toggleTheme(),
      ),
    );
  }

  void _showThemeMenu(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('Ikuti Pengaturan Sistem'),
              trailing: themeProvider.themeMode == ThemeMode.system
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                themeProvider.useSystemTheme();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Tema Terang'),
              trailing: themeProvider.themeMode == ThemeMode.light
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Tema Gelap'),
              trailing: themeProvider.themeMode == ThemeMode.dark
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
