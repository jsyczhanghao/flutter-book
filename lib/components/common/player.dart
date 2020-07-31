import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Player extends StatelessWidget {
  final Widget child;

  Player({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child, 
        // Positioned(
        //   bottom: 30,
        //   left: 30,
        //   child: Hero(
        //     tag: 'player',
        //     child: Container(width: 100, height: 100, color: Colors.red,),
        //   ),
        // ),
      ],
    );
  }
}