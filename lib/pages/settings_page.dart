import 'package:flutter/material.dart';
import 'package:rosantibike_mobile/api/auth_api,dart';
import 'package:rosantibike_mobile/pages/auth/login_page.dart';
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
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
        return;
      }

      final authApi = AuthApi();
      bool isLoggedOut = await authApi.logout(token); // Pass the token

      if (isLoggedOut) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Settings Page'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _logout(context),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
