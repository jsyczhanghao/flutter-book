import 'package:flutter/material.dart';
import './const.dart';
import './font.dart';
import './theme.dart';
import './progress.dart';
import './configs.dart';

class ReaderSupportFooter extends StatefulWidget {
  final Function onChangeFont;
  final Function onChangeProgress;
  final Function onChangeTheme;
  final ReaderSupportConfigs configs;

  ReaderSupportFooter(
      {Key key, this.configs, this.onChangeFont, this.onChangeTheme, this.onChangeProgress})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReaderSupportFooterState();
  }
}

class ReaderSupportFooterState extends State<ReaderSupportFooter> {
  int _i = 0;

  onSwitchPanel(int i) {
    _i = i;
    setState(() {});
  }

  Widget renderSupportPanel() {
    if (_i == 0) {
      return ReaderSupportProgress(
        onChange: widget.onChangeProgress,
        index: widget.configs.index,
        total: widget.configs.total,
      );
    } else if (_i == 1) {
      return ReaderSupportTheme(
        onChange: widget.onChangeTheme,
        theme: widget.configs.theme
      );
    } else if (_i == 2) {
      return ReaderSupportFont(
        onChange: widget.onChangeFont,
        size: widget.configs.fontSize,
        family: widget.configs.fontFamily,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Container(
          height: 1,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.7), blurRadius: 3)
          ]),
        ),
        renderSupportPanel(),
        Container(
          height: 60,
          color: ReaderSupportConst.COLOR,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: ReaderSupportConst.SETTINGS.map((Map setting) {
              return IconButton(
                icon: Icon(setting['icon']),
                color: setting['value'] == _i
                    ? ReaderSupportConst.SELECTED_ICON_COLOR
                    : ReaderSupportConst.ICON_COLOR,
                onPressed: () => onSwitchPanel(setting['value']),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
