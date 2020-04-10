import 'package:flutter/material.dart';
import 'package:simple_status_bar/simple_status_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple status bar'),
        ),
        drawer: SimpleDrawer(
          drawerCallback: (bool isOpened) {
            SimpleStatusBar.toggle(hide: isOpened, animation: StatusBarAnimation.SLIDE);
          },
          background: Colors.green,
          child: Column(children: <Widget>[]),
        ),
        body: Center(
          child: Text("Synchronized toggle of status bar with drawer."),
        ),
      ),
    );
  }

  //
}
