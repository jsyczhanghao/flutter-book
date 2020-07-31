import 'dart:async';
import 'package:flutter/material.dart';
import './const.dart';

class ReaderSupportFont extends StatefulWidget {
  final double size;
  final String family;
  final Function onChange;

  ReaderSupportFont({Key key, this.size, this.family, this.onChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReaderSupportFontState();
  }
}

class ReaderSupportFontState extends State<ReaderSupportFont> {
  Timer timer;
  double _size;
  String _family;

  @override
  initState() {
    super.initState();
    _size = widget.size;
    _family = widget.family;
  }

  triggerChange() {
    setState(() {});

    if (timer != null) {
      timer.cancel();
    }

    timer = Timer(Duration(milliseconds: 500), () {
      widget.onChange(_family, _size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ReaderSupportConst.COLOR,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(1),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    '选择字体',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                    children: ReaderSupportConst.FONTS.map(
                  (Map font) {
                    return Container(
                      height: 30,
                      width: 90,
                      child: FlatButton(
                        color: _family == font['value']
                            ? ReaderSupportConst.SELECTED_ICON_COLOR
                            : null,
                        child: Text(
                          font['name'],
                          style: TextStyle(
                            fontFamily: font['value'],
                            fontSize: 14,
                            color: _family == font['value']
                                ? Colors.white
                                : ReaderSupportConst.ICON_COLOR,
                          ),
                        ),
                        onPressed: () {
                          _family = font['value'];
                          triggerChange();
                        },
                      ),
                    );
                  },
                ).toList()),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 80,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  '选择大小',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Slider(
                  value: _size,
                  min: ReaderSupportConst.FONT_MIN_SIZE,
                  max: ReaderSupportConst.FONT_MAX_SIZE,
                  label: _size.toInt().toString(),
                  divisions: 6,
                  onChanged: (val) {
                    _size = val;
                    triggerChange();
                  },
                ),
              ),
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  '傻',
                  style: TextStyle(fontSize: _size),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
