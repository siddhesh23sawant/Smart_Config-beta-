import 'package:flutter/material.dart';
import 'Base.dart';
import 'constants.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: kPrimaryColor,
                title: Text('Smart Configuration')
            ),
            body: BaseApp()
        )
    );
  }
}