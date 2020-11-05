import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_config/constants.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:io' show Platform;

import 'attack.dart';

// void main() => runApp(new MyApp());

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: kPrimaryColor,
                title: Text('Smart Configuration')
            ),
            body: Config_page(),
    ),
    );
  }
}

class Config_page extends StatefulWidget {
  @override
  _Config_pageState createState() => _Config_pageState();
}

class _Config_pageState extends State<Config_page> {
  @override
  Widget build(BuildContext poContext) {
    return Scaffold(body: getWidgets(poContext));
  }

  List<WifiNetwork> _htResultNetwork = [];
  bool _isEnabled = false;
  bool _isConnected = false;
  String ssid = "";
  @override
  initState() {
    getWifis();

    super.initState();
  }

  getWifis() async {
    _isEnabled = await WiFiForIoTPlugin.isEnabled();
    _isConnected = await WiFiForIoTPlugin.isConnected();
    _htResultNetwork = await loadWifiList();
    setState(() {});
    if (_isConnected) {
      WiFiForIoTPlugin.getSSID().then((value) => setState(() {
        ssid = value;
      }));
    }
  }

  Future<List<APClient>> getClientList(
      bool onlyReachables, int reachableTimeout) async {
    List<APClient> htResultClient;
    try {
      htResultClient = await WiFiForIoTPlugin.getClientList(
          onlyReachables, reachableTimeout);
    } on PlatformException {
      htResultClient = List<APClient>();
    }

    return htResultClient;
  }

  Future<List<WifiNetwork>> loadWifiList() async {
    List<WifiNetwork> htResultNetwork;
    try {
      htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
    } on PlatformException {
      htResultNetwork = List<WifiNetwork>();
    }

    return htResultNetwork;
  }

  isRegisteredWifiNetwork(String ssid) {
    return ssid == this.ssid;
  }

  Widget getWidgets(context) {
    WiFiForIoTPlugin.isConnected().then((val) => setState(() {
      _isConnected = val;
    }));

    return SingleChildScrollView(
      child: Column(
        children: getButtonWidgetsForAndroid(context),
      ),
    );
  }

  List<Widget> getButtonWidgetsForAndroid(context) {
    List<Widget> htPrimaryWidgets = List();
    WiFiForIoTPlugin.isEnabled().then((val) => setState(() {
      _isEnabled = val;
    }));
    htPrimaryWidgets.addAll({
      Text('\nStep 1 :'),
      Text('Turn on Wi-fi network\n'),
      Container(
        child: ListTile(
            leading: Text('Wi-Fi',
            style: TextStyle(
                fontSize: 16
            ),
            ),
            trailing: Switch(
                value: _isEnabled,
                onChanged: (v) {
                  if (_isEnabled) {
                    WiFiForIoTPlugin.setEnabled(false);
                  } else {
                    WiFiForIoTPlugin.setEnabled(true);
                    getWifis();
                  }
                  setState(() {
                    _isEnabled = !_isEnabled;
                  });
                })),
        // color: _isEnabled ? kPrimaryColor : kBackgroundColor,
      ),
      SizedBox(height: 10),
      Text('Step 2 :'),
      Text('Connect With Wi-Fi Network of Smart Device\n'),
      Text(
        'Available Wi-Fi Networks',
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            getWifis();
          }),
      getList(context)
    });
    if (_isEnabled) {
      WiFiForIoTPlugin.isConnected().then((val) {
        if (val != null) {
          setState(() {
            _isConnected = val;
          });
        }
      });
    }

    return htPrimaryWidgets;
  }

  getList(contex) {
    return ListView.builder(
      itemBuilder: (builder, i) {
        var network = _htResultNetwork[i];
        var isConnctedWifi = false;
        if (_isConnected)
          isConnctedWifi = isRegisteredWifiNetwork(network.ssid);

        if (_htResultNetwork != null && _htResultNetwork.length > 0) {
          return Container(
            color: isConnctedWifi ? Colors.blueAccent : Colors.transparent,
            child: ListTile(
              title: Text(network.ssid),
              trailing: !isConnctedWifi
                  ? OutlineButton(
                      onPressed: () {
                        Navigator.of(contex).push(MaterialPageRoute(
                            builder: (_) => Attack(
                                  wifiNetwork: network,
                                )));
                      },
                      child: Text('Connect'),
                    )
                  : SizedBox()
            ),
          );
        } else
          return Center(
            child: Text('No wifi found'),
          );
      },
      itemCount: _htResultNetwork.length,
      shrinkWrap: true,
    );
  }
}

class PopupCommand {
  String command;
  String argument;

  PopupCommand(this.command, this.argument);
}

//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String _wifiName = 'click button to get wifi ssid.';
//   int level = 0;
//   String _ip = 'click button to get ip.';
//   List<WifiResult> ssidList = [];
//   String ssid = '', password = '';
//
//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Smart Device Network'),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: kPrimaryColor,
//       ),
//       body: SafeArea(
//         child: ListView.builder(
//           padding: EdgeInsets.all(20.0),
//           itemCount: ssidList.length + 1,
//           itemBuilder: (BuildContext context, int index) {
//             return itemSSID(index);
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget itemSSID(index) {
//     if (index == 0) {
//       return Column(
//         children: [
//           // Row(
//           //   children: <Widget>[
//           //     RaisedButton(
//           //       child: Text('ssid'),
//           //       onPressed: _getWifiName,
//           //     ),
//           //     Offstage(
//           //       offstage: level == 0,
//           //       child: Image.asset(level == 0 ? 'images/wifi1.png' : 'images/wifi$level.png', width: 28, height: 21),
//           //     ),
//           //     Text(_wifiName),
//           //   ],
//           // ),
//           // Row(
//           //   children: <Widget>[
//           //     RaisedButton(
//           //       child: Text('ip'),
//           //       onPressed: _getIP,
//           //     ),
//           //     Text(_ip),
//           //   ],
//           // ),
//           TextField(
//             decoration: InputDecoration(
//               border: UnderlineInputBorder(),
//               filled: true,
//               icon: Icon(Icons.wifi),
//               hintText: 'Your wifi ssid',
//               labelText: 'ssid',
//             ),
//             keyboardType: TextInputType.text,
//             onChanged: (value) {
//               ssid = value;
//             },
//           ),
//           TextField(
//             decoration: InputDecoration(
//               border: UnderlineInputBorder(),
//               filled: true,
//               icon: Icon(Icons.lock_outline),
//               hintText: 'Your wifi password',
//               labelText: 'password',
//             ),
//             keyboardType: TextInputType.text,
//             onChanged: (value) {
//               password = value;
//             },
//           ),
//           RaisedButton(
//             child: Text('connection'),
//             onPressed: connection,
//           ),
//         ],
//       );
//     } else {
//       return Column(children: <Widget>[
//         Center(
//           child: Align(
//             alignment: Alignment(-1, 1),
//             child: Text('Available Wi-Fi Networks\n',),
//           ),
//         ),
//         ListTile(
//           leading: Image.asset('images/wifi${ssidList[index - 1].level}.png', width: 28, height: 21),
//           title: Text(
//             ssidList[index - 1].ssid,
//             style: TextStyle(
//               color: Colors.black87,
//               fontSize: 16.0,
//             ),
//           ),
//           dense: true,
//         ),
//         Divider(),
//       ]);
//     }
//   }
//
//   void loadData() async {
//     Wifi.list('').then((list) {
//       setState(() {
//         ssidList = list;
//       });
//     });
//   }
//
//   Future<Null> _getWifiName() async {
//     int l = await Wifi.level;
//     String wifiName = await Wifi.ssid;
//     setState(() {
//       level = l;
//       _wifiName = wifiName;
//     });
//   }
//
//   Future<Null> _getIP() async {
//     String ip = await Wifi.ip;
//     setState(() {
//       _ip = ip;
//     });
//   }
//
//   Future<Null> connection() async {
//     Wifi.connection(ssid, password).then((v) {
//       print(v);
//     });
//   }
// }