import 'package:jdsaa/base/algorithm.dart';

///冒泡排序
class BubbleSort with IAlgorithm {
  static final BubbleSort _singleton = BubbleSort._internal();

  BubbleSort._internal();

  factory BubbleSort() => _singleton;

  ///
  @override
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) async* {
    for (var i = from; i < to - 1; i++) {
      for (var j = from; j < to - i - 1; j++) {
        num temp1 = datas[j];
        num temp2 = datas[j + 1];
        bool hasChange = false;
        if (hasChange = (temp1 > temp2)) {
          datas[j] = temp2;
          datas[j + 1] = temp1;
        }
        yield AStep(type: hasChange ? AStepType.swap : AStepType.find, idxs: [j, j + 1]);
      }
    }
    yield AStep.done;
  }
}

void main(List<String> args) {
  BubbleSort().sort([100, -1, 50, 7, 2, 30]).forEach((element) {
    // ignore: avoid_print
    if (element.type == AStepType.done) print("result = ${element.value}");
  });
}
