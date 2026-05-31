import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Safewebview extends StatefulWidget {
  final String url;

  const Safewebview({super.key, required this.url});

  @override
  State<Safewebview> createState() => _SafewebviewState();
}

class _SafewebviewState extends State<Safewebview> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Article")),
      body: WebViewWidget(controller: controller),
    );
  }
}