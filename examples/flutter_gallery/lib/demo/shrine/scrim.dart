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
    print('Scrim.widget.controller = ${widget.controller}');
    final Size deviceSize = MediaQuery.of(context).size;
    print('Scrim.widget.controller.value = ${widget.controller.value}');
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, Widget child) {
        final Color color = Color.fromRGBO(0xFF, 0xF0, 0xEA, widget.controller.value * 0.87);
        return Container(width: deviceSize.width, height: deviceSize.height, color: color);
      }
    );

      //Container(width: deviceSize.width, height: deviceSize.height * _controller.value, color: Colors.blue);
  }
}
