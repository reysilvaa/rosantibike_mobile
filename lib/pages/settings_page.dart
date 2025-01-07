
import 'package:flutter/material.dart';
import 'package:rosantibike_mobile/api/auth_api,dart';
import 'package:rosantibike_mobile/pages/auth/login_page.dart';
import 'package:rosantibike_mobile/widgets/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No token found. Please log in again.')),
        );
        _navigateToLogin(context);
        return;
      }

      final authApi = AuthApi();
      bool isLoggedOut = await authApi.logout(token);

      if (isLoggedOut) {
        _navigateToLogin(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: HeaderWidget(title: 'Pengaturan'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Section
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                                'assets/images/profile_placeholder.jpg'),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'RosantiBike Admin',
                            style: theme.textTheme.titleLarge,
                          ),
                          Text(
                            'rosantibike@gmail.com',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white60
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Menu Items
                    // _buildMenuItem(
                    //   context: context,
                    //   icon: Icons.person_outline,
                    //   title: 'My Profile',
                    //   onTap: () {},
                    // ),
                    // _buildMenuItem(
                    //   context: context,
                    //   icon: Icons.notifications_none,
                    //   title: 'Notification',
                    //   onTap: () {},
                    // ),
                    // _buildMenuItem(
                    //   context: context,
                    //   icon: Icons.history,
                    //   title: 'History',
                    //   onTap: () {},
                    // ),
                    // _buildMenuItem(
                    //   context: context,
                    //   icon: Icons.card_membership,
                    //   title: 'My Subscription',
                    //   onTap: () {},
                    // ),
                    // _buildMenuItem(
                    //   context: context,
                    //   icon: Icons.settings_outlined,
                    //   title: 'Setting',
                    //   onTap: () {},
                    // ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.help_outline,
                      title: 'Pusat Bantuan',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.logout,
                      title: 'Keluar',
                      onTap: () => _logout(context),
                      isDestructive: true,
                    ),
                    SizedBox(height: 15)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final Color itemColor =
        isDestructive ? theme.colorScheme.error : theme.iconTheme.color!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: itemColor,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: itemColor,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: theme.iconTheme.color?.withOpacity(0.5),
          size: 16,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
