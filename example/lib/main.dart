import 'package:flutter/material.dart';
import 'package:simple_status_bar/simple_status_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hide = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple status bar'),
        ),
        body: Center(
          child: RaisedButton(
            child: Text(this.hide ? 'Show' : 'Hide'),
            onPressed: () async {
              final bool result = await SimpleStatusBar.toggle(
                hidden: !this.hide,
                animation: StatusBarAnimation.SLIDE,
              );
              if (result) {
                setState(() {
                  this.hide = !hide;
                });
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Unable to toggle...")));
              }
            },
          ),
        ),
      ),
    );
  }

  //
}
