import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

class Scrim extends StatefulWidget {
  const Scrim({this.controller});

  final AnimationController controller;

  @override
  _ScrimState createState() => _ScrimState();
}

class _ScrimState extends State<Scrim> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    print(_controller.value);
    return Container(width: deviceSize.width, height: deviceSize.height * _controller.value, color: Colors.blue);
  }
}
