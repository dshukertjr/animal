import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  static Route<dynamic> route({
    @required String title,
    @required String url,
  }) {
    return MaterialPageRoute(
      builder: (context) => WebviewPage(
        title: title,
        url: url,
      ),
    );
  }

  final String url;
  final String title;

  const WebviewPage({
    Key key,
    @required this.url,
    @required this.title,
  }) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebView(
        initialUrl: widget.url,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
