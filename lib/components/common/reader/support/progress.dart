import 'dart:async';
import 'package:flutter/material.dart';
import './const.dart';

class ReaderSupportProgress extends StatefulWidget {
  final Function(int) onChange;
  final int index;
  final int total;
  final double progress;

  ReaderSupportProgress({Key key, this.progress, this.index, this.total, this.onChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReaderSupportProgressState();
  }
}

class ReaderSupportProgressState extends State<ReaderSupportProgress> {
  double _val;
  Timer timer;

  initState() {
    super.initState();
    _val = analyseVal(widget.index);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _val = analyseVal(widget.index);
    setState(() {
      
    });
  }

  double analyseVal(int index) {
    return (100 * index / widget.total).toDouble();
  }

  onChange (double val) {
    int index = (val / 100 * widget.total).toInt();

    if (index > widget.total - 1) {
      index = widget.total - 1;
    }

    _val = analyseVal(index);

    setState(() {});

    if (timer != null) {
      timer.cancel();
    }

    timer = Timer(Duration(seconds: 1), () {
      widget.onChange(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ReaderSupportConst.COLOR,
      height: 80,
      child: Slider(
        min: 0,
        max: 100,
        divisions: 200,
        value: _val,
        label: '${_val.toStringAsFixed(2)}%',
        onChanged: onChange,
      ),
    );
  }
}
