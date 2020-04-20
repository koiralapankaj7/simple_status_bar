import 'package:flutter/material.dart';
import 'package:simple_status_bar/simple_status_bar.dart';
import 'package:simple_status_bar/simple_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //

  SystemUiMode systemTheme;
  Brightness brightness = Brightness.light;

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
            // Container(
            //   color: Colors.grey.shade300,
            //   padding: EdgeInsets.all(12.0),
            //   child: Wrap(
            //     alignment: WrapAlignment.spaceBetween,
            //     runSpacing: 16.0,
            //     spacing: 16.0,
            //     children: colors
            //         .map((Color color) => GestureDetector(
            //               onTap: () {
            //                 SimpleStatusBar.changeStatusBarColor(color: color);
            //                 print(color.value);
            //               },
            //               child: CircleAvatar(
            //                 backgroundColor: color,
            //               ),
            //             ))
            //         .toList(),
            //   ),
            // ),
            SizedBox(height: 30.0),
            Text(systemTheme.toString()),
            Text(brightness.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    final result = await SimpleStatusBar.getSystemUiMode();
                    setState(() {
                      systemTheme = result;
                    });
                  },
                  child: Text("Get theme"),
                ),
                RaisedButton(
                  onPressed: _toggleBrightnessPressed,
                  child: Text("Toggle Brightness"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onGetThemePressed() async {
    final result = await SimpleStatusBar.getSystemUiMode();
    setState(() {
      systemTheme = result;
    });
  }

  void _toggleBrightnessPressed() async {
    print("Toogle brightness clicked");
    final Brightness bright =
        this.brightness == Brightness.light ? Brightness.dark : Brightness.light;
    await SimpleStatusBar.changeStatusBarBrightness(brightness: bright);
    setState(() {
      this.brightness = bright;
    });
    print("Brightness toggled");
  }
}
