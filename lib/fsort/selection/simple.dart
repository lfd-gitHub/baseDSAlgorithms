import 'package:jdsaa/base/algorithm.dart';

///simple selection sort
class SimpleSort with IAlgorithm {
  static final SimpleSort _singleton = SimpleSort._internal();
  SimpleSort._internal();

  factory SimpleSort() => _singleton;

  @override
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) async* {
    int len = to - from;
    for (var i = from; i < len; i++) {
      var temp = datas[i];
      //find smallest from last area
      for (var j = i + 1; j < len; j++) {
        if (temp > datas[j]) {
          datas[i] = datas[j];
          datas[j] = temp;
          temp = datas[i];
          yield AStep(type: AStepType.swap, idxs: [i, j]);
        }
      }
    }
    yield AStep.done;
  }
}
