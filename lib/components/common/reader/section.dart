import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ReaderSectionStyle {
  final double width;
  final double height;
  final BoxDecoration decoration;

  ReaderSectionStyle({this.width, this.height, this.decoration});
}

class ReaderSection extends StatelessWidget {
  final int index;
  final String text;
  final ReaderSectionStyle style;

  ReaderSection({
    Key key,
    this.text,
    this.index = 0,
    this.style,
  }) : super(key: key);

  Widget render() {
    return Container(
      width: style.width,
      height: style.height,
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Positioned(
            top: -index * style.height,
            child: Container(
              width: style.width,
              height: (index + 1) * style.height,
              child: Text(
                text,
                textScaleFactor: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderLoading() {
    return CupertinoActivityIndicator(radius: 18.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: style.decoration,
      child: Center(
        child: text == null ? renderLoading() : render(),
      ),
    );
  }
}
