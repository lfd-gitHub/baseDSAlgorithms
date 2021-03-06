// ignore_for_file: avoid_print, unused_local_variable

import 'dart:math';

import 'package:jdsaa/base/algorithm.dart';

class ShellSort with IAlgorithm {
  static final ShellSort _singleton = ShellSort._internal();
  ShellSort._internal();

  factory ShellSort() => _singleton;

  @override
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) async* {
    int len = to - from;
    int gapSize = len ~/ 2;

    while (gapSize >= 1) {
      for (var i = gapSize + from; i < len; i++) {
        log("[group] @$gapSize->$i");
        for (var j = i - gapSize; j >= from; j -= gapSize) {
          var temp = datas[j];
          if (temp > datas[j + gapSize]) {
            datas[j] = datas[j + gapSize];
            datas[j + gapSize] = temp;
            log("compare and swap $j/${j + gapSize} | [${datas[j]},${datas[j + gapSize]}]");
            yield AStep(type: AStepType.swap, idxs: [j, j + gapSize]);
          } else {
            log("break because left has sorted $j/${j + gapSize} | [${datas[j]},${datas[j + gapSize]}]");
            yield AStep(type: AStepType.find, idxs: [j, j + gapSize]);
            break;
          }
        }
      }
      gapSize = gapSize ~/ 2;
    }

    yield AStep.done;
  }
}

void log(String msg) => print(msg);

void main(List<String> args) async {
  var list = List.generate(10, (index) => Random().nextInt(100) - 50);
  print("before : $list");
  var ss = ShellSort().sort(list);
  await for (var s in ss) {}
  print("after : $list");
}
