// ignore_for_file: avoid_print

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
          //find correct position at left
          if (datas[j - 1] > datas[j]) {
            //swap
            num temp = datas[j - 1];
            datas[j - 1] = datas[j];
            datas[j] = temp;
            logd("swrap left $j <-> ${j - 1} => $datas");
            yield AStep(type: AStepType.swap, idxs: [j - 1, j]);
          }
        }
      }
    }
  }
}

void logd(s) => //
    {}; //
//print("$s");

void main(List<String> args) {
  var datas = List.generate(10, (index) => Random().nextInt(100) - 50);
  print("sort before = $datas");
  DirectISort().sort(datas);
  print("sort after = $datas");
}
