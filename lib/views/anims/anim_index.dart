import 'dart:async';
import 'dart:math' as m;
import 'package:flutter/material.dart';
import 'package:jdsaa/aarray/bi_search.dart';
import 'package:jdsaa/base/algorithm.dart';
import 'package:jdsaa/fsort/insert/shell.dart';
import 'package:jdsaa/fsort/swap/bubble.dart';
import 'package:jdsaa/fsort/insert/direct.dart';
import 'package:jdsaa/fsort/swap/quick.dart';
import 'package:jdsaa/views/widgets/anim_pillar.dart';
import 'package:rxdart/rxdart.dart';

class AnimIndexPage extends StatefulWidget {
  const AnimIndexPage({Key? key}) : super(key: key);

  @override
  State<AnimIndexPage> createState() => _AnimIndexPageState();
}

class _AnimIndexPageState<T extends num> extends State<AnimIndexPage> {
  /////////////////////////////
  final portalHeight = 300.0;
  final contentPadding = 8.0;
  final itemSpace = 4.0;
  final pillarDuration = const Duration(milliseconds: 100);
  final stepDuration = const Duration(milliseconds: 200);
  /////////////////////////////

  num maxValue = 0;
  num minValue = 0;
  List<num> datas = [];
  AStep? marked; //标记时标记的坐标
  AStep? aStep;
  int steps = 0; // 步数
  int menuAlgorIdx = 0; //选择的算法
  double findWhat = 0; // 查找目标值
  List<String> supportAlgor = [
    (BiSearch).toString(),
    (BubbleSort).toString(),
    (QuickSort).toString(),
    (DirectISort).toString(),
    (ShellSort).toString(),
  ];
  /////////////////////////////
  StreamSubscription? stepStreamSub;

  List<num> inputDatas = [];

  void onInputChange(String value) {
    if (value.contains(",")) {
      inputDatas = value.split(",").map((e) => num.tryParse(e) ?? 0).toList();
    }
    if (value.isEmpty) inputDatas = [];
    findWhat = double.tryParse(value) ?? 0;
  }

  void onChangeAlgor(int idx) {
    setState(() {
      stepStreamSub?.cancel();
      aStep = null;
      generateDatas(supportAlgor[idx]);
      menuAlgorIdx = idx;
    });
  }

  @override
  void dispose() {
    stepStreamSub?.cancel();
    super.dispose();
  }

  void startAnim() {
    marked = null;
    steps = 0;
    stepStreamSub?.cancel();
    Stream<AStep>? stepStream;
    void Function(AStep)? listener = _sortUpdate;
    var _datas = List.of(datas);
    switch (supportAlgor[menuAlgorIdx]) {
      case 'BiSearch':
        stepStream = BiSearch().find(_datas, findWhat);
        listener = _searchUpdate;
        break;
      case 'QuickSort':
        stepStream = QuickSort().sortRange(_datas, 0, datas.length - 1);
        break;
      case 'BubbleSort':
        stepStream = BubbleSort().sort(_datas);
        break;
      case 'DirectISort':
        stepStream = DirectISort().sort(_datas);
        break;
      case 'ShellSort':
        stepStream = ShellSort().sort(_datas);
        break;
      default:
        break;
    }
    stepStreamSub = stepStream?.interval(stepDuration).map((event) {
      steps++;
      return event;
    }).listen(listener);
  }

  void _sortUpdate(AStep event) {
    log("[Sort][refresh] $event");
    aStep = event;
    if (aStep?.type == AStepType.done) {
      datas = aStep!.value;
    } else if (aStep?.type == AStepType.swap) {
      int from = aStep!.idxs![0];
      int to = aStep!.idxs![1];
      var temp = datas[from];
      datas[from] = datas[to];
      datas[to] = temp;
    } else if (aStep?.type == AStepType.update) {
      datas[aStep!.idxs![0]] = aStep!.value;
    } else if (aStep?.type == AStepType.mark) {
      marked = aStep;
    }
    setState(() {});
  }

  void _searchUpdate(AStep event) {
    aStep = event;
    setState(() {});
  }

  @override
  void initState() {
    generateDatas((BiSearch).toString());
    super.initState();
  }

  void generateDatas(String algor) {
    switch (algor) {
      case 'ShellSort':
      case 'DirectISort':
      case 'QuickSort':
      case 'BubbleSort':
        if (inputDatas.isNotEmpty) {
          datas = List.of(inputDatas);
        } else if (datas.isEmpty || supportAlgor[menuAlgorIdx].toUpperCase().endsWith('SEARCH')) {
          datas = List.generate(30, (index) => m.Random().nextInt(100) - 50);
        }
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
      appBar: AppBar(title: Text("STEPS = [ $steps ]")),
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
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 30,
                    child: TextField(
                      onChanged: onInputChange,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      style: const TextStyle(overflow: TextOverflow.visible, fontSize: 16, height: 1.2),
                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.zero),
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
                    if (aStep?.type == AStepType.swap) {
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
                      if (marked?.idxs?.first == i) {
                        sIdx = "#";
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
                            if (perValueWidth >= 10)
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
                              perValueWidth < 10 ? sIdx : "$sIdx \n $i",
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
      if (marked?.value != null && aStep?.isShowMarked == true) {
        var markedValue = marked!.value;
        double itemHeight = perValueHeight * (markedValue - minValue) + minValueHeight;
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
