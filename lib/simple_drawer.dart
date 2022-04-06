import 'package:flutter/material.dart';

typedef _DrawerCallback = void Function(bool opened);

class SimpleDrawer extends StatefulWidget {
  final _DrawerCallback? drawerCallback;
  final Widget child;
  final double? width;
  final Color? background;

  const SimpleDrawer({
    Key? key,
    this.drawerCallback,
    required this.child,
    this.width,
    this.background,
  }) : super(key: key);

  @override
  _SimpleDrawerState createState() => _SimpleDrawerState();
}

class _SimpleDrawerState extends State<SimpleDrawer> {
  @override
  void initState() {
    super.initState();
    widget.drawerCallback!(true);
  }

  @override
  void dispose() {
    widget.drawerCallback!(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: widget.width ?? constraints.maxWidth * 0.8,
          color: widget.background ?? Colors.white,
          child: widget.child,
        );
      },
    );
  }
}
