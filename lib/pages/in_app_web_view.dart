import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rosantibike_mobile/main.dart';

// Define the MyInAppBrowser class
class MyInAppBrowser extends InAppBrowser {
  MyInAppBrowser({super.webViewEnvironment});

  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $url");
  }

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    print("Can't load ${request.url}.. Error: ${error.description}");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }
}

// Create a wrapper StatefulWidget to launch MyInAppBrowser
class InAppBrowserWidget extends StatefulWidget {
  const InAppBrowserWidget({Key? key}) : super(key: key);

  @override
  _InAppBrowserWidgetState createState() => _InAppBrowserWidgetState();
}

class _InAppBrowserWidgetState extends State<InAppBrowserWidget> {
  late MyInAppBrowser _browser;

  @override
  void initState() {
    super.initState();
    _browser = MyInAppBrowser(webViewEnvironment: webViewEnvironment);
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri("https://flutter.dev")),
      onWebViewCreated: (controller) {
        _browser.onBrowserCreated();
      },
      onLoadStart: (controller, url) {
        _browser.onLoadStart(url);
      },
      onLoadStop: (controller, url) {
        _browser.onLoadStop(url);
      },
      onReceivedError: (controller, request, error) {
        _browser.onReceivedError(request, error);
      },
      onProgressChanged: (controller, progress) {
        _browser.onProgressChanged(progress);
      },
    );
  }
}
