import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../tasks/tts/tts.dart';
import '../../libs/libs.dart';
import 'package:path_provider/path_provider.dart';

class IfTts extends StatefulWidget {
  final Widget child;

  IfTts({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return IfTtsState();
  }
}

class IfTtsState extends State<IfTts> with TickerProviderStateMixin {
  BookChapterModel _chapter;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    controller.repeat();
    refreshTtsStorage();
  }

  refreshTtsStorage() async {
    TtsStorage storage = await TtsStorage.get();
  String dir = (await getApplicationDocumentsDirectory()).path;
  print(dir);
    if (storage == null) {
      setState(() {
        _chapter = null;
      });

      return;
    }

    setState(() {
      _chapter = storage.model;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(IfTts oldWidget) {
    super.didUpdateWidget(oldWidget);
    refreshTtsStorage();
  }

  renderChild() {
    if (_chapter == null || _chapter.id == null) {
      return Container();
    }

    return Hero(
      child: Stack(
        children: <Widget>[
          Container(
            width: 110,
            height: 60,
            padding: EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular((60.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                )
              ],
            ),
            child: GestureDetector(
              child: Icon(Icons.close),
              onTap: () async {
                await TtsController.stop();
                refreshTtsStorage();
              },
            ),
          ),
          Positioned(
            top: 6,
            left: 6,
            child: RotationTransition(
              turns: controller,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/book/iftts', arguments: _chapter.book);
                },
                child: ClipOval(
                  child: Image(
                    image: Helper.image(_chapter.book.img),
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      tag: 'player',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Positioned(
          bottom: 100,
          left: 5,
          child: renderChild(),
        ),
      ],
    );
  }
}
