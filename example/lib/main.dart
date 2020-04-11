import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:simple_status_bar/simple_status_bar.dart';
import 'package:simple_status_bar/simple_drawer.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //

  SystemTheme systemTheme;
  final List<Color> colors = [
    Colors.blue.shade50,
    Colors.green,
    Colors.cyan,
    Colors.yellow.shade200,
    Colors.grey,
    Colors.pink.shade100,
    Colors.black,
    Colors.white,
    Colors.lightBlue,
    Colors.brown,
    Colors.deepOrange,
    Colors.indigo.shade300,
    Colors.teal,
  ];

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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text("Synchronized status bar toggle with drawer."),
            ),
            SizedBox(height: 30.0),
            Text(systemTheme.toString()),
            Container(
              color: Colors.grey.shade300,
              padding: EdgeInsets.all(12.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 16.0,
                spacing: 16.0,
                children: colors
                    .map((Color color) => GestureDetector(
                          onTap: () {
                            SimpleStatusBar.changeColor(color: color);
                          },
                          child: CircleAvatar(
                            backgroundColor: color,
                          ),
                        ))
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    final result = await SimpleStatusBar.getSystemTheme();
                    setState(() {
                      systemTheme = result;
                    });
                  },
                  child: Text("Get theme"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
