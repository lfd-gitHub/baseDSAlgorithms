// ignore_for_file: avoid_print, unused_local_variable

import 'dart:math';

import 'package:jdsaa/base/algorithm.dart';

class DirectISort with IAlgorithm {
  static final DirectISort _singleton = DirectISort._internal();
  DirectISort._internal();

  factory DirectISort() => _singleton;

  @override
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) async* {
    for (var i = from + 1; i < to; i++) {
      //select the first unsorted element
      var fue = datas[i];
      yield AStep(type: AStepType.find, idxs: [i]);
      for (var j = i; j > from; j--) {
        //continue find correct position at left where already sorted.
        if (datas[j - 1] > datas[j]) {
          //swap
          num temp = datas[j - 1];
          datas[j - 1] = datas[j];
          datas[j] = temp;
          logd("swrap left $j <-> ${j - 1} => $datas");
          yield AStep(type: AStepType.swap, idxs: [j - 1, j]);
          continue;
        }
        break;
      }
    }
    yield AStep.done;
  }
}

void main(List<String> args) async {
  var datas = List.generate(10, (index) => Random().nextInt(100) - 50);
  print("sort before = $datas");
  var ss = DirectISort().sort(datas);
  await for (var s in ss) {}
  print("sort after = $datas");
}
