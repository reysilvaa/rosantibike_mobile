// lib/pages/wallets_page.dart
import 'package:flutter/material.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Wallets Page'),
        ),
      ),
    );
  }
}