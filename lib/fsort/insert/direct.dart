// ignore_for_file: avoid_print, unused_local_variable

import 'dart:math';

import 'package:jdsaa/base/algorithm.dart';

class DirectISort with IAlgorithm {
  static final DirectISort _singleton = DirectISort._internal();
  DirectISort._internal();

  factory DirectISort() => _singleton;

  @override
  Stream<AStep> sort(List<num> datas) async* {
    for (var i = 1; i < datas.length; i++) {
      //select the first unsorted element
      var fue = datas[i];
      yield AStep(type: AStepType.find, idxs: [i]);
      if (fue < datas[i - 1]) {
        //swap
        datas[i] = datas[i - 1];
        datas[i - 1] = fue;
        yield AStep(type: AStepType.swap, idxs: [i - 1, i]);
        logd("swrap $i <-> ${i - 1} => $datas");
        for (var j = i - 1; j > 0; j--) {
          //continue find correct position at left where already sorted.
          if (datas[j - 1] > datas[j]) {
            //swap
            num temp = datas[j - 1];
            datas[j - 1] = datas[j];
            datas[j] = temp;
            logd("swrap left $j <-> ${j - 1} => $datas");
            yield AStep(type: AStepType.swap, idxs: [j - 1, j]);
          } else {
            logd("compare and no swap $j/${j - 1} | [${datas[j - 1]},${datas[j]}]");
            yield AStep(type: AStepType.find, idxs: [j - 1, j]);
          }
        }
      }
    }
    yield AStep.done;
  }
}

void logd(s) => //
    {}; //
//print("$s");

void main(List<String> args) async {
  var datas = List.generate(10, (index) => Random().nextInt(100) - 50);
  print("sort before = $datas");
  var ss = DirectISort().sort(datas);
  await for (var s in ss) {}
  print("sort after = $datas");
}
