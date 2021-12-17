import 'package:jdsaa/base/algorithm.dart';

///冒泡排序
class BubbleSort with IAlgorithm {
  static final BubbleSort _singleton = BubbleSort._internal();

  BubbleSort._internal();

  factory BubbleSort() => _singleton;

  ///
  @override
  Stream<AStep> sort(List<num> datas) async* {
    List<num> copy = List.of(datas);
    for (int i = 0; i < datas.length - 1; i++) {
      for (var j = 0; j < datas.length - i - 1; j++) {
        num temp1 = copy[j];
        num temp2 = copy[j + 1];
        bool hasChange = false;
        if (hasChange = (temp1 > temp2)) {
          copy[j] = temp2;
          copy[j + 1] = temp1;
        }
        yield AStep(type: hasChange ? AStepType.swap : AStepType.find, idxs: [j, j + 1]);
      }
    }
    yield AStep(type: AStepType.done, value: copy);
  }
}

void main(List<String> args) {
  BubbleSort().sort([100, -1, 50, 7, 2, 30]).forEach((element) {
    // ignore: avoid_print
    if (element.type == AStepType.done) print("result = ${element.value}");
  });
}
