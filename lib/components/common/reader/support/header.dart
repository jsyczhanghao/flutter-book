import 'package:flutter/material.dart';
import './const.dart';
import './action.dart';

class ReaderSupportHeader extends StatefulWidget {
  final List<ReaderSupportAction> actions;
  final Function onActionPressed;

  ReaderSupportHeader({Key key, this.actions, this.onActionPressed}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return ReaderSupportHeaderState();
  }
}

class ReaderSupportHeaderState extends State<ReaderSupportHeader> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ReaderSupportConst.COLOR,
      actionsIconTheme: IconThemeData(color: ReaderSupportConst.ICON_COLOR),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: ReaderSupportConst.ICON_COLOR,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: widget.actions.map((ReaderSupportAction action) {
        return IconButton(
          icon: action.icon,
          onPressed: () {
            action.onPressed();
            widget.onActionPressed();
          },
        );
      }).toList(),
    );
  }
}
