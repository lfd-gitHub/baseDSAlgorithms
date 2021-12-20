import 'package:jdsaa/base/algorithm.dart';

///simple selection sort
class SimpleSort with IAlgorithm {
  static final SimpleSort _singleton = SimpleSort._internal();
  SimpleSort._internal();

  factory SimpleSort() => _singleton;

  @override
  Stream<AStep> sort(List<num> datas) async* {
    int n = datas.length;
    for (var i = 0; i < n; i++) {
      var temp = datas[i];
      //find smallest from last area
      for (var j = i + 1; j < n; j++) {
        if (temp > datas[j]) {
          datas[i] = datas[j];
          datas[j] = temp;
          temp = datas[i];
          yield AStep(type: AStepType.swap, idxs: [i, j]);
        } else {
          yield AStep(type: AStepType.find, idxs: [i, j]);
        }
      }
    }
  }
}
