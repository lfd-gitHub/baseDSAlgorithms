// ignore_for_file: avoid_print
import 'dart:math';

import 'package:jdsaa/base/algorithm.dart';

///快速排序
class QuickSort with IAlgorithm {
  static final QuickSort _singleton = QuickSort._internal();
  QuickSort._internal();

  factory QuickSort() => _singleton;

  @override
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) async* {
    int compIdx = from;
    var compValue = datas[from];
    int i = compIdx;
    int j = to - 1;

    yield AStep(type: AStepType.mark, idxs: [compIdx], value: compValue, isShowMarked: true);
    logd("[Start] base:[$compIdx/$compValue] i = $i, j = $j | ${datas.getRange(from, to)}");
    while (i != j) {
      while (i != j) {
        if (datas[j] > compValue) {
          yield AStep(idxs: [i, j], isShowMarked: true);
          j--;
          logd("[CompTail] move j-- = $j");
        } else {
          datas[i] = datas[j];
          yield AStep(type: AStepType.swap, idxs: [i, j], isShowMarked: true);
          i++;
          logd("[CompTail] exchange and move i++ = $i | $datas");
          break;
        }
      }

      while (i != j) {
        if (datas[i] < compValue) {
          yield AStep(idxs: [i, j], isShowMarked: true);
          i++;
          logd("[CompHead] move i++ = $i");
        } else {
          datas[j] = datas[i];
          yield AStep(type: AStepType.swap, idxs: [i, j], isShowMarked: true);
          j--;
          logd("[CompHead] exchange and move j-- = $j $datas");
          break;
        }
      }

      if (i == j) {
        datas[i] = compValue;
        logd("[CompSame][$i] recurse [$from,${i - 1}] & [${i + 1},$to]  | $datas");
        yield AStep(type: AStepType.update, idxs: [i], value: compValue, isShowMarked: true);
        if (from < i - 1) {
          logd("[RecurseHead] ${datas.getRange(from, i + 1)}");
          yield* sortRange(datas, from, i);
        }
        if (i + 1 < to - 1) {
          logd("[RecurseTail] ${datas.getRange(i + 1, to)}");
          yield* sortRange(datas, i + 1, to);
        }
        yield AStep.done;
        return;
      }
    }
  }
}

void logd(String msg) => print(msg);

void main(List<String> args) async {
  var datas = List.generate(30, (index) => Random().nextInt(1000) - 500);
  // QuickSort().sortRange(datas, 0, datas.length - 1);
  print("datas $datas");
  var ss = QuickSort().sort(datas);
  await for (var item in ss) {
    print("result = $datas");
    print("step = $item");
  }
  print("result = $datas");
}
