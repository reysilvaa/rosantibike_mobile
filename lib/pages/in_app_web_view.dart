import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/bottom_navigation_widget.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';

class MyInAppBrowser extends InAppBrowser {
  MyInAppBrowser({super.webViewEnvironment});

  @override
  Future onBrowserCreated() async {
    debugPrint("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    debugPrint("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    debugPrint("Stopped $url");
  }

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    debugPrint("Can't load ${request.url}.. Error: ${error.description}");
  }

  @override
  void onProgressChanged(progress) {
    debugPrint("Progress: $progress");
  }

  @override
  void onExit() {
    debugPrint("Browser closed!");
  }
}

class InAppBrowserWidget extends StatefulWidget {
  const InAppBrowserWidget({Key? key}) : super(key: key);

  @override
  _InAppBrowserWidgetState createState() => _InAppBrowserWidgetState();
}

class _InAppBrowserWidgetState extends State<InAppBrowserWidget> {
  late MyInAppBrowser _browser;
  static WebViewEnvironment? webViewEnvironment;
  bool _isLoading = true;
  double _loadingProgress = 0.0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebViewEnvironment();
    _browser = MyInAppBrowser(webViewEnvironment: webViewEnvironment);
  }

  Future<void> _initializeWebViewEnvironment() async {
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
        final availableVersion = await WebViewEnvironment.getAvailableVersion();
        if (availableVersion == null) {
          setState(() {
            _errorMessage =
                'WebView2 Runtime not found. Please install it to continue.';
          });
          return;
        }

        webViewEnvironment = await WebViewEnvironment.create(
          settings: WebViewEnvironmentSettings(
            userDataFolder: 'YOUR_CUSTOM_PATH',
          ),
        );
      }

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize WebView: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, themeProvider),
            Expanded(
              child: Stack(
                children: [
                  if (_errorMessage != null)
                    ErrorDisplay(
                      message: _errorMessage!,
                      onRetry: () {
                        setState(() {
                          _errorMessage = null;
                          _initializeWebViewEnvironment();
                        });
                      },
                    )
                  else
                    InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: WebUri("https://rosantibikemotorent.com/booking"),
                      ),
                      onWebViewCreated: (controller) {
                        _browser.onBrowserCreated();
                      },
                      onLoadStart: (controller, url) {
                        setState(() {
                          _isLoading = true;
                        });
                        _browser.onLoadStart(url);
                      },
                      onLoadStop: (controller, url) {
                        setState(() {
                          _isLoading = false;
                        });
                        _browser.onLoadStop(url);
                      },
                      onReceivedError: (controller, request, error) {
                        setState(() {
                          _errorMessage = error.description;
                        });
                        _browser.onReceivedError(request, error);
                      },
                      onProgressChanged: (controller, progress) {
                        setState(() {
                          _loadingProgress = progress / 100;
                        });
                        _browser.onProgressChanged(progress);
                      },
                    ),
                  if (_isLoading) LoadingIndicator(progress: _loadingProgress),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final double progress;

  const LoadingIndicator({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
        if (progress < 1.0)
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Loading... ${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
      ],
    );
  }
}

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorDisplay({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, ThemeProvider themeProvider) {
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Booking',
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            fontWeight: FontWeight.bold,
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
              icon: Icon(Icons.refresh, color: theme.iconTheme.color),
              onPressed: () {
                // Add refresh functionality
              },
            ),
          ],
        ),
      ],
    ),
  );
}
