
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VCQRU Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController _webViewController;
  late PullToRefreshController _pullToRefreshController;
  double _progress = 0;
  final String _url = 'https://dashboard.vcqru.com/';

  @override
  void initState() {
    super.initState();
    _pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
        } else {
          _webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(_url)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VCQRU Dashboard'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(_url)),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            pullToRefreshController: _pullToRefreshController,
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
            onLoadStop: (controller, url) {
              _pullToRefreshController.endRefreshing();
            },
          ),
          if (_progress < 1.0)
            LinearProgressIndicator(value: _progress),
        ],
      ),
    );
  }
}
