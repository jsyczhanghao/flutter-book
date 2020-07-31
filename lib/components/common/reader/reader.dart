import 'package:flutter/material.dart';
import 'package:tf_toast/Toast.dart';
import '../../../libs/libs.dart';
import './size.dart';
import './section.dart';
import './support/support.dart';
export './support/support.dart';
export './size.dart';

class Reader extends StatefulWidget {
  final int page;
  final String title;
  final String text;
  final ReaderSupportConfigs configs;
  final Function(int, bool) onSwitchChapter;
  final Function(int) onSwitchPage;
  final Function(ReaderSupportConfigs) onSwitchConfigs;

  Reader({
    Key key,
    this.title,
    this.page,
    this.text,
    this.configs,
    this.onSwitchChapter,
    this.onSwitchPage,
    this.onSwitchConfigs,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReaderState();
  }
}

class ReaderState extends State<Reader> {
  int _page = 0;
  ReaderSupportConfigs _configs;
  PagingData pagingData;

  @override
  void initState() {
    super.initState();
    _configs = widget.configs;
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _configs = widget.configs;
    _page = widget.page;
    analyse();
  }

  void analyse() async {
    ReaderSize size = ReaderSize(context);

    pagingData = PagingAnalyser(Size(size.width, size.height))
        .analyse(text: widget.text, style: getStyle());

    widget.onSwitchPage(_page = _page > pagingData.pages - 1 ? pagingData.pages - 1 : _page);
    setState(() {});
  }

  Color getColor() {
    return ReaderSupportConst.THEMES[_configs.theme]['color'];
  }

  BoxDecoration getDecoration() {
    return ReaderSupportConst.THEMES[_configs.theme]['decoration'];
  }

  TextStyle getStyle() {
    return TextStyle(
      color: getColor(),
      fontSize: _configs.fontSize,
      fontFamily: _configs.fontFamily,
      height: PagingAnalyser.INLINE_HEIGHT_SCALE,
    );
  }

  onSwitchPage(dp) {
    if (dp == -1) {
      if (_page > 0) {
        _page--;
        widget.onSwitchPage(_page);
        setState(() {});
      } else if (widget.configs.index > 0) {
        widget.onSwitchChapter(-1, false);
      } else {
        Toast.show(context, title: '没有上一页啦~~', duration: 1);
      }
    } else if (dp == 1) {
      if (_page < pagingData.pages - 1) {
        _page++;
        widget.onSwitchPage(_page);
        setState(() {});
      } else if (widget.configs.index < widget.configs.total - 1) {
        widget.onSwitchChapter(1, false);
      } else {
        Toast.show(context, title: '看完啦~~', duration: 1);
      }
    }
  }

  onSwitchFont(String family, double size) {
    widget.onSwitchConfigs(_configs = ReaderSupportConfigs.from(
      _configs,
      fontFamily: family,
      fontSize: size,
    ));
    analyse();
  }

  onSwitchProgress(int index) {
    widget.onSwitchConfigs(ReaderSupportConfigs.from(
      _configs,
      index: index,
    ));
  }

  onSwitchTheme(int theme) {
    widget.onSwitchConfigs(_configs = ReaderSupportConfigs.from(
      _configs,
      theme: theme,
    ));
    setState(() {});
  }

  ReaderSection renderSection() {
    return ReaderSection(
      index: _page,
      text: widget.text,
      style: ReaderSectionStyle(
        width: pagingData.size.width,
        height: pagingData.size.height,
        decoration: getDecoration(),
      ),
    );
  }

  Positioned renderChapterBasicInfo() {
    TextStyle basicStyle = TextStyle(
      inherit: false,
      fontSize: 11,
      color: getColor(),
      fontWeight: FontWeight.bold,
    );

    EdgeInsets padding = MediaQuery.of(context).padding;

    return Positioned(
      bottom: padding.bottom == 0 ? 10 : padding.bottom,
      left: ReaderSize.PADDING_LR,
      right: ReaderSize.PADDING_LR,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.title.length > 30 ? widget.title.substring(0, 30) + '...' : widget.title,
            style: basicStyle,
          ),
          Text(
            '${_page + 1}/${pagingData.pages}',
            style: basicStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (pagingData == null) {
      return ReaderSection(
        style: ReaderSectionStyle(
          decoration: getDecoration(),
        ),
      );
    }

    return ReaderSupport(
      configs: _configs,
      onSwitchPage: onSwitchPage,
      onSwitchFont: onSwitchFont,
      onSwitchProgress: onSwitchProgress,
      onSwitchTheme: onSwitchTheme,
      child: DefaultTextStyle(
        style: getStyle(),
        child: Stack(
          children: <Widget>[
            renderSection(),
            renderChapterBasicInfo(),
          ],
        ),
      ),
    );
  }
}
