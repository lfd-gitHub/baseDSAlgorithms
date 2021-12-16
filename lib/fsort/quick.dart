// ignore_for_file: avoid_print
import 'dart:math';

import 'package:jdsaa/base/algorithm.dart';

class QuickSort with IAlgorithm {
  static final QuickSort _singleton = QuickSort._internal();
  QuickSort._internal();

  factory QuickSort() => _singleton;

  // @override
  // Stream<AStep> sort(List<num> datas) {

  // }

  @override
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) async* {
    int compIdx = from;
    var compValue = datas[from];
    int i = compIdx;
    int j = to;

    logd("[Start] base:[$compIdx/$compValue] i = $i, j = $j | ${datas.getRange(from, to + 1)}");
    while (i != j) {
      while (i != j) {
        if (datas[j] > compValue) {
          yield AStep(idxs: [i, j], isExchagne: false, markIndex: compIdx, value: compValue);
          j--;
          logd("[CompTail] move j-- = $j");
        } else {
          datas[i] = datas[j];
          yield AStep(idxs: [i, j], isExchagne: true, markIndex: compIdx, type: AStepType.exchange, value: compValue);
          i++;
          logd("[CompTail] exchange and move i++ = $i | $datas");
          break;
        }
      }

      while (i != j) {
        if (datas[i] < compValue) {
          yield AStep(idxs: [i, j], isExchagne: false, markIndex: compIdx, value: compValue);
          i++;
          logd("[CompHead] move i++ = $i");
        } else {
          datas[j] = datas[i];
          yield AStep(idxs: [i, j], isExchagne: true, markIndex: compIdx, type: AStepType.exchange, value: compValue);
          j--;
          logd("[CompHead] exchange and move j-- = $j $datas");
          break;
        }
      }

      if (i == j) {
        datas[i] = compValue;
        logd("[CompSame][$i] recurse [$from,${i - 1}] & [${i + 1},$to]  | $datas");
        yield AStep(idxs: [i], type: AStepType.update, value: compValue, markIndex: compIdx);
        if (from < i - 1) {
          logd("[RecurseHead] ${datas.getRange(from, i)}");
          yield* sortRange(datas, from, i - 1);
        }
        if (i + 1 < to) {
          logd("[RecurseTail] ${datas.getRange(i + 1, to + 1)}");
          yield* sortRange(datas, i + 1, to);
        }
        return;
      }
    }
  }
}

void logd(String msg) => print(msg);

void main(List<String> args) async {
  var datas = List.generate(100, (index) => Random().nextInt(1000) - 500);
  // QuickSort().sortRange(datas, 0, datas.length - 1);
  print("datas $datas");
  var ss = QuickSort().sortRange(datas, 0, datas.length - 1);
  await for (var item in ss) {
    print("result = $datas");
    print("step = $item");
  }
  print("result = $datas");
}
