import 'package:flutter/material.dart';
import './const.dart';

class ReaderSupportTheme extends StatefulWidget {
  final int theme;
  final Function onChange;

  ReaderSupportTheme({Key key, this.theme, this.onChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReaderSupportThemeState();
  }
}

class ReaderSupportThemeState extends State<ReaderSupportTheme> {
  int _theme;

  @override
  initState() {
    super.initState();
    _theme = widget.theme;
  }

  triggerChange() {
    widget.onChange(_theme);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      color: ReaderSupportConst.COLOR,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ReaderSupportConst.THEMES.map((theme) {
          return Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            color: _theme == theme['value'] ? Colors.grey.withOpacity(0.3) : Colors.transparent,
            child: FlatButton(
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: theme['decoration'],
                child: Text(
                  '傻',
                  style: TextStyle(
                    color: theme['color'],
                    fontSize: 20,
                  ),
                ),
              ),
              onPressed: () {
                _theme = theme['value'];
                triggerChange();
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
