// ignore_for_file: avoid_print, unused_local_variable

import 'dart:math';

import 'package:jdsaa/base/algorithm.dart';

class MergeSort with IAlgorithm {
  static final sTAG = (MergeSort).toString();

  static final MergeSort _singleton = MergeSort._internal();
  MergeSort._internal();

  factory MergeSort() => _singleton;

  @override
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) async* {
    int midIdx = (from + to - 1) ~/ 2;
    logd("[$sTAG] find midIdx $midIdx from range [$from,${to - 1}] | $datas");

    if (from < midIdx) {
      logd("[$sTAG] sort left [$from,$midIdx] | $datas");
      yield AStep(type: AStepType.find, idxs: [from, midIdx]);
      yield* sortRange(datas, from, midIdx + 1);
    }
    if (midIdx + 1 < to - 1) {
      logd("[$sTAG] sort right [${midIdx + 1},$to] | $datas");
      yield AStep(type: AStepType.find, idxs: [midIdx + 1, to - 1]);
      yield* sortRange(datas, midIdx + 1, to);
    }

    //merge left and right
    logd("[$sTAG] start merge ${datas.getRange(from, to)}");
    for (var i = midIdx + 1; i < to; i++) {
      for (var j = i; j > from; j--) {
        if (datas[j] < datas[j - 1]) {
          logd("[$sTAG] swap [${j - 1},$j] | ${datas.getRange(from, to)}");
          swap(datas, j - 1, j);
          yield AStep(type: AStepType.swap, idxs: [j - 1, j]);
          continue;
        }
        break;
      }
    }
    logd("[$sTAG] end merge ${datas.getRange(from, to)}");

    yield AStep.done;
  }
}

void main(List<String> args) async {
  var datas = List.generate(20, (i) => Random().nextInt(100) - 50);
  logd("[main] prepare datas = $datas");
  var ss = MergeSort().sortRange(datas, 0, datas.length);
  await for (var item in ss) {}
  logd("[main] result datas = $datas");
}
