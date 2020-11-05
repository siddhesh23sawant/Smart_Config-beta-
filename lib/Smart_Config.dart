import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'constants.dart';


class WebViewLoad extends StatefulWidget {

  WebViewLoadUI createState() => WebViewLoadUI();

}

class WebViewLoadUI extends State<WebViewLoad>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text('Smart Configuration')),
      body: WebView(
        initialUrl: 'http://askautomationserver.club/Smart_Config/config.html',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}