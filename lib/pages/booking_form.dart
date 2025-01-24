import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/constants/my_in_app_webview.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';

class BookingForm extends StatelessWidget {
  const BookingForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return InAppWebViewWidget(
      url: 'https://rosantibikemotorent.com/booking',
      title: 'Booking',
    );
  }
}
