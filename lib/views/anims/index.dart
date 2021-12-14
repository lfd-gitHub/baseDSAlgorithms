import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:jdsaa/aarray/bi_search.dart';
import 'package:jdsaa/base/algorithm.dart';
import 'package:jdsaa/views/widgets/anim_pillar.dart';
import 'package:jdsaa/views/widgets/data_sheet.dart';
import 'package:jdsaa/views/widgets/data_widget.dart';

class AnimIndexPage extends StatefulWidget {
  late final List<num> datas;

  AnimIndexPage({Key? key, required List<num> datas}) : super(key: key) {
    this.datas = List.of(datas);
  }

  @override
  State<AnimIndexPage> createState() => _AnimIndexPageState();
}

class _AnimIndexPageState<T extends num> extends State<AnimIndexPage> {
  final portalHeight = 300.0;
  final contentPadding = 8.0;
  final itemSpace = 4.0;
  late List<num> datas;
  num maxValue = 0;
  num minValue = 0;
  late AStep aStep;

  double findWhat = 0;

  final StreamController<AStep> _stepStream = StreamController.broadcast();

  Stream<AStep> stepStream() {
    return _stepStream.stream;
  }

  void onInputChange(String value) {
    findWhat = double.tryParse(value) ?? 0;
  }

  @override
  void dispose() {
    _stepStream.close();
    super.dispose();
  }

  void biFind() async {
    int idx = await BiSearch().find(datas, findWhat, (s) async {
      if (_stepStream.isClosed) {
        return;
      }
      while (_stepStream.isPaused) {
        await Future.delayed(const Duration(seconds: 1));
      }
      log("biFind s => $s");
      _stepStream.add(s);
      await Future.delayed(const Duration(seconds: 1));
    });
    _stepStream.add(AStep(idxs: [idx]));
    log("biFind s => $idx");
  }

  @override
  void initState() {
    datas = widget.datas;
    super.initState();
    maxValue = datas.reduce((curr, next) => curr > next ? curr : next);
    minValue = datas.reduce((curr, next) => curr < next ? curr : next);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find or exchange by index"),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              onPressed: () => DataSheet.show(ctx, widget.datas),
              icon: const Icon(Icons.expand),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: OrientationBuilder(builder: (ctx, orientation) {
          bool isPortal = orientation == Orientation.portrait;
          return Column(
            children: [
              Expanded(child: _buildPillar(isPortal)),
              Row(
                children: [
                  const SizedBox(width: 8.0),
                  OutlinedButton.icon(
                    onPressed: () {
                      biFind();
                    },
                    icon: const Icon(Icons.play_circle_outline_sharp),
                    label: const Text("开始 "),
                  ),
                  const SizedBox(width: 8.0),
                  SizedBox(
                    width: 100,
                    height: 30,
                    child: TextField(
                      onChanged: onInputChange,
                      keyboardType: TextInputType.number,
                      //style: (decorationStyle: const InputDecoration(border: OutlineInputBorder())),
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton(
                      value: 1,
                      items: const [
                        DropdownMenuItem<int>(child: Text("BiSearch"), value: 1),
                        DropdownMenuItem<int>(child: Text("test2"), value: 2),
                        DropdownMenuItem<int>(child: Text("test3"), value: 3),
                      ],
                      onChanged: null)
                ],
              ),
              if (isPortal)
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DataWidget(datas: widget.datas),
                )),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPillar(bool isPortal) {
    return LayoutBuilder(builder: (ctx, cs) {
      final maxHeight = cs.biggest.height;
      final width = cs.maxWidth;
      log("maxHeight = $maxHeight");
      double height = isPortal ? portalHeight : maxHeight;
      double minValueHeight = 10;
      double labelHeight = 20;
      double perValueHeight = (height - minValueHeight - labelHeight - contentPadding * 2) / (maxValue - minValue);
      double perValueWidth = (width - contentPadding * 2 - itemSpace * datas.length + itemSpace) / datas.length;

      Widget item = Container(
        padding: EdgeInsets.all(contentPadding),
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: StreamBuilder<AStep>(
                stream: stepStream(),
                builder: (context, ss) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (var i = 0; i < datas.length; i++) ...[
                        SizedBox(width: i > 0 ? itemSpace : 0),
                        Builder(builder: (ctx) {
                          var dataValue = datas[i];
                          double itemHeight = perValueHeight * (dataValue - minValue) + minValueHeight;

                          var sIdx = "";
                          if (ss.hasData && ss.data?.idxs != null) {
                            if (ss.data!.idxs.contains(i)) {
                              sIdx = "↑";
                            }
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Stack(
                                children: [
                                  AnimPillar(
                                    width: perValueWidth,
                                    heightFrom: itemHeight,
                                    heightTo: itemHeight,
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      child: SizedBox(
                                        width: perValueWidth,
                                        child: Text(
                                          "$dataValue",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.white, fontSize: 8),
                                        ),
                                      ))
                                ],
                              ),
                              Container(
                                color: sIdx.isNotEmpty ? Colors.amber : null,
                                height: labelHeight,
                                width: perValueWidth,
                                child: Center(
                                  child: Text(
                                    "$sIdx \n $i",
                                    style: const TextStyle(fontSize: 8),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          );
                        })
                      ]
                    ],
                  );
                }),
          ),
        ),
      );

      return item;
    });
  }
}
