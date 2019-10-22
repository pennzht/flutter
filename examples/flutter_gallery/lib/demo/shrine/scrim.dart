import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

class Scrim extends StatefulWidget {
  const Scrim({this.controller});

  final AnimationController controller;

  @override
  _ScrimState createState() => _ScrimState();
}

class _ScrimState extends State<Scrim> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, Widget child) {
        final Color color = Color.fromRGBO(0xFF, 0xF0, 0xEA, widget.controller.value * 0.87);
        return IgnorePointer(child: Container(width: deviceSize.width, height: deviceSize.height, color: color));
      }
    );
  }
}
