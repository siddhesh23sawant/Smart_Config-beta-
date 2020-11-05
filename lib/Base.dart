import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';
import 'Avail_net.dart';
import 'constants.dart';




class BaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
        children: <Widget>[
          Spacer(),
          Text('\nStep 1:'),
            Center(
        child: Text('\nBefore Configuring a Smart Device,\n'
            'Make Sure Your Wi-Fi is Turned On\n'),
            ),
          Text('Step 2:'),
          Center(
            child: Text('\nSelect & Connect with Wi-Fi Network of Smart Device,\n'),
          ),
          Text('Step 3:'),
          Center(
            child: Text('\nFill the Form with Proper Details,\n'),
          ),
          Spacer(),
          Align(
          child: FloatingActionButton.extended(
            elevation: 50,
            hoverElevation: 50,
            label: Text('Start Configuration'),
            icon: Icon(Icons.thumb_up),
            backgroundColor: kPrimaryColor,
            onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondRoute()),
              );
            },
            ),
             alignment: Alignment.bottomCenter,
         ),
          Spacer(),
        ],
        ),
    );
  }
}