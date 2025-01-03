import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart';

// Define the custom MyInAppBrowser class
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

// Define a StatefulWidget to launch MyInAppBrowser
class InAppBrowserWidget extends StatefulWidget {
  const InAppBrowserWidget({Key? key}) : super(key: key);

  @override
  _InAppBrowserWidgetState createState() => _InAppBrowserWidgetState();
}

class _InAppBrowserWidgetState extends State<InAppBrowserWidget> {
  late MyInAppBrowser _browser;
  static WebViewEnvironment? webViewEnvironment;

  @override
  void initState() {
    super.initState();

    _initializeWebViewEnvironment();
    _browser = MyInAppBrowser(webViewEnvironment: webViewEnvironment);
  }

  // Move the WebView environment initialization here
  Future<void> _initializeWebViewEnvironment() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      final availableVersion = await WebViewEnvironment.getAvailableVersion();
      assert(availableVersion != null,
          'Failed to find an installed WebView2 Runtime or non-stable Microsoft Edge installation.');

      webViewEnvironment = await WebViewEnvironment.create(
        settings: WebViewEnvironmentSettings(userDataFolder: 'YOUR_CUSTOM_PATH'),
      );
    }

    // Enable debugging for Android
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
    }
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
