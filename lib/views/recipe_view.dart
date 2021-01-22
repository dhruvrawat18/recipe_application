import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class RecipeView extends StatefulWidget {
  final String postUrl;
  RecipeView({this.postUrl});
  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  String finalUrl;
  final Completer<WebViewController> _completer =
      new Completer<WebViewController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.postUrl.contains("http://")) {
      finalUrl = widget.postUrl.replaceAll("http://", "https://");
    } else {
      finalUrl = widget.postUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WebView(
            initialUrl: finalUrl,
            onWebViewCreated: (WebViewController webViewController) {
              setState(() {
                _completer.complete(webViewController);
              });
            },
          ),
        ),
      ),
    );
  }
}
