import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:smart_config/constants.dart';

import 'constants.dart';

class Attack extends StatefulWidget {
  final WifiNetwork wifiNetwork;

  const Attack({Key key, this.wifiNetwork}) : super(key: key);
  @override
  _AttackState createState() => _AttackState();
}

class _AttackState extends State<Attack> {
  int count = 0;
  String result = "", currentPass = '';
  bool done = false, success = false;
  @override
  void initState() {
    super.initState();
    startAttack();
  }

  startAttack() async {
    loop:
    for (var i = 0; i < PASSWORDS.length; i++) {
      setState(() {
        currentPass = PASSWORDS[i];
      });
      var isConnected = await WiFiForIoTPlugin.connect(widget.wifiNetwork.ssid,
          security: NetworkSecurity.WPA, password: PASSWORDS[i]);
      if (isConnected) {
        setState(() {
          success = true;
          done = true;
          result = "Attack Successful";
        });
        break loop;
      }
      count++;
      setState(() {});
      if (count == PASSWORDS.length) {
        setState(() {
          done = true;
        });
        if (!isConnected) {
          setState(() {
            result = "Attack Failed";
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Connected to " + widget.wifiNetwork.ssid),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text('Step 3 :'),
          Text('Get the Services and fill the Credentials of User\n'),
          Center(
            child: RaisedButton(
                      onPressed: () {
                        // Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => WebViewLoad()
                        ),
                        );
                      },
                      child: Text('Get Service'),
                    ),
          ),

          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class WebViewLoad extends StatefulWidget {

  WebViewLoadUI createState() => WebViewLoadUI();

}

class WebViewLoadUI extends State<WebViewLoad>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('Smart Configuration')),
      body: WebView(
        initialUrl: 'http://192.168.4.1',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}