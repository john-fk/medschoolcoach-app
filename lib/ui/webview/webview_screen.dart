import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  final String title;
  final String initialUrl;

  const WebviewScreen(
      {Key key, @required this.title, @required this.initialUrl})
      : super(key: key);

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: widget.title),
          Expanded(child: _buildContent())
        ],
      ),
    );
  }

  Widget _buildContent() {
    return WebView(
        initialUrl: widget.initialUrl,
        key: widget.key,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) =>
            webViewController.loadUrl(widget.initialUrl));
  }
}
