import 'dart:async';
import 'dart:developer';
import 'dart:math' as m;
import 'package:flutter/material.dart';
import 'package:jdsaa/aarray/bi_search.dart';
import 'package:jdsaa/base/algorithm.dart';
import 'package:jdsaa/fsort/bubble.dart';
import 'package:jdsaa/fsort/quick.dart';
import 'package:jdsaa/views/widgets/anim_pillar.dart';
import 'package:rxdart/rxdart.dart';

class AnimIndexPage extends StatefulWidget {
  const AnimIndexPage({Key? key}) : super(key: key);

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
  AStep? aStep;
  final pillarDuration = const Duration(milliseconds: 100);
  final stepDuration = const Duration(milliseconds: 200);

  double findWhat = 0;
  List<String> supportAlgor = [(BiSearch).toString(), (BubbleSort).toString(), (QuickSort).toString()];

  StreamSubscription? _stepStreamSub;

  void onInputChange(String value) {
    findWhat = double.tryParse(value) ?? 0;
  }

  int menuAlgorIdx = 0;
  void onChangeAlgor(int idx) {
    setState(() {
      menuAlgorIdx = idx;
      generateDatas(supportAlgor[idx]);
    });
  }

  @override
  void dispose() {
    _stepStreamSub?.cancel();
    super.dispose();
  }

  void startAnim() {
    switch (supportAlgor[menuAlgorIdx]) {
      case 'QuickSort':
        _quickSort();
        break;
      case 'BubbleSort':
        _bubbleSort();
        break;
      case 'BiSearch':
        _biFind();
        break;
      default:
        break;
    }
  }

  void _quickSort() {
    _stepStreamSub?.cancel();
    Stream<AStep> steps = QuickSort().sortRange(List.of(datas), 0, datas.length - 1);
    _stepStreamSub = steps.interval(stepDuration).listen((event) {
      setState(() {
        log("[Sort][refresh] $event");
        aStep = event;
        if (aStep?.isExchagne == true) {
          int from = aStep!.idxs![0];
          int to = aStep!.idxs![1];
          var temp = datas[from];
          datas[from] = datas[to];
          datas[to] = temp;
        }
        if (aStep?.type == AStepType.update) {
          datas[aStep!.idxs![0]] = aStep!.value;
        }
      });
    });
  }

  void _bubbleSort() {
    _stepStreamSub?.cancel();
    Stream<AStep> steps = BubbleSort().sort(datas);
    _stepStreamSub = steps.interval(stepDuration).listen((event) {
      setState(() {
        log("[Sort][refresh] $event");
        aStep = event;
        if (aStep?.type == AStepType.result) {
          datas = aStep!.value;
        } else if (aStep?.isExchagne == true) {
          int from = aStep!.idxs![0];
          int to = aStep!.idxs![1];
          var temp = datas[from];
          datas[from] = datas[to];
          datas[to] = temp;
        }
      });
    });
  }

  void _biFind() {
    _stepStreamSub?.cancel();
    Stream<AStep> steps = BiSearch().find(datas, findWhat);
    _stepStreamSub = steps.interval(stepDuration).listen((event) {
      setState(() {
        //log("[Find][refresh] $event");
        aStep = event;
      });
    });
  }

  @override
  void initState() {
    generateDatas((BiSearch).toString());
    super.initState();
  }

  void generateDatas(String algor) {
    switch (algor) {
      case 'QuickSort':
      case 'BubbleSort':
        datas = List.generate(30, (index) => m.Random().nextInt(100) - 50);
        break;
      case 'BiSearch':
      default:
        datas = List.generate(30, (index) => index);
    }
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
        // actions: [
        //   Builder(
        //     builder: (ctx) => IconButton(
        //       onPressed: () => DataSheet.show(ctx, datas),
        //       icon: const Icon(Icons.expand),
        //     ),
        //   ),
        // ],
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
                    onPressed: startAnim,
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
                    value: menuAlgorIdx,
                    items: [
                      for (var i = 0; i < supportAlgor.length; i++) //
                        DropdownMenuItem<int>(child: Text(supportAlgor[i]), value: i)
                    ],
                    onChanged: (int? idx) => onChangeAlgor(idx ?? 0),
                  ),
                ],
              ),
              // if (isPortal)
              //   Expanded(
              //       child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: DataWidget(datas: datas),
              //   )),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < datas.length; i++) ...[
                  SizedBox(width: i > 0 ? itemSpace : 0),
                  Builder(builder: (ctx) {
                    var idxFrom = -1;
                    bool? isToRight;
                    if (aStep?.isExchagne == true) {
                      if (i == aStep!.idxs![0]) {
                        isToRight = false;
                        idxFrom = aStep!.idxs![1];
                      } else if (i == aStep!.idxs![1]) {
                        isToRight = true;
                        idxFrom = aStep!.idxs![0];
                      } else {
                        isToRight = null;
                      }
                    }

                    Color color = Colors.blue;
                    var dataValue = datas[i];
                    var dataFrom = idxFrom < 0 ? dataValue : datas[idxFrom];

                    // if (aStep?.markIndex == i) {
                    //   if (aStep?.value == dataValue || aStep?.type == AStepType.find) {
                    //     if (dataFrom == dataValue) color = Colors.blueAccent;
                    //   }
                    // }
                    if (aStep?.type == AStepType.update && aStep?.idxs?[0] == i) {
                      color = Colors.red;
                    }

                    double itemHeight = perValueHeight * (dataValue - minValue) + minValueHeight;
                    double itemHeightFrom = perValueHeight * (dataFrom - minValue) + minValueHeight;

                    var sIdx = "";
                    if (aStep?.idxs != null) {
                      if (aStep?.idxs?.contains(i) ?? false) {
                        sIdx = "↑";
                      }
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            AnimPillar(
                              key: ValueKey(dataValue),
                              duration: pillarDuration,
                              color: color,
                              width: perValueWidth,
                              heightFrom: itemHeightFrom,
                              heightTo: itemHeight,
                              isTopIn: isToRight == null,
                              isRightIn: isToRight ?? false,
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
            ),
          ),
        ),
      );
      double lineTop = 0;
      double lineHeigh = 1;
      if (aStep?.markIndex != null && aStep?.value != null) {
        double itemHeight = perValueHeight * (aStep!.value - minValue) + minValueHeight;
        lineTop = height - itemHeight - labelHeight - contentPadding;
      }
      return Stack(
        children: [
          item,
          Positioned(
              top: lineTop,
              child: Container(
                color: Colors.green,
                width: cs.maxWidth,
                height: lineHeigh,
              )),
        ],
      );
    });
  }
}
