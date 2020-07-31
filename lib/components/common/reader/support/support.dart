import 'package:flutter/material.dart';
import './header.dart';
import './footer.dart';
import './configs.dart';

export './configs.dart';
export './const.dart';
export './action.dart';

class ReaderSupport extends StatefulWidget {
  final Widget child;
  final ReaderSupportConfigs configs;
  final Function onSwitchPage;
  final Function onSwitchFont;
  final Function onSwitchProgress;
  final Function onSwitchTheme;

  ReaderSupport({
    Key key,
    @required this.child,
    this.configs,
    this.onSwitchPage,
    this.onSwitchFont,
    this.onSwitchProgress,
    this.onSwitchTheme,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReaderSupportState();
  }
}

class ReaderSupportState extends State<ReaderSupport>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  bool _actived = false;
  static const SUPPORT_PANEL_MAX_HEIGHT = 190;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    animation = Tween<double>(begin: -1, end: 0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      });
  }

  void onTap(TapUpDetails e) {
    double x = e.globalPosition.dx / MediaQuery.of(context).size.width;

    if (_actived) {
      _actived = false;
      controller.reverse();
    } else if (x < 0.25) {
      widget.onSwitchPage(-1);
    } else if (x > 0.75) {
      widget.onSwitchPage(1);
    } else if (!_actived) {
      _actived = true;
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.clip,
      children: <Widget>[
        GestureDetector(
          child: widget.child,
          onTapUp: onTap,
        ),
        Positioned(
          top: animation.value * SUPPORT_PANEL_MAX_HEIGHT,
          right: 0,
          left: 0,
          child: ReaderSupportHeader(
            actions: widget.configs.actions,
            onActionPressed: () {
              setState(() {
                _actived = false;
                controller.reverse();
              });
            },
          ),
        ),
        Positioned(
          bottom: animation.value * SUPPORT_PANEL_MAX_HEIGHT,
          left: 0,
          right: 0,
          child: ReaderSupportFooter(
            onChangeFont: widget.onSwitchFont,
            onChangeProgress: widget.onSwitchProgress,
            onChangeTheme: widget.onSwitchTheme,
            configs: widget.configs,
          ),
        ),
      ],
    );
  }
}
