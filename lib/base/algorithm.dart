abstract class IAlgorithm {
  Stream<AStep> find(List<num> datas, num target) => throw 'not implement';
  Stream<AStep> sort(List<num> datas) => sortRange(datas, 0, datas.length);
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) => throw 'not implement';
}

// ignore_for_file: avoid_print
void logd(String msg) => print(msg);

void swap(List<num> datas, int left, int right) {
  var temp = datas[right];
  datas[right] = datas[left];
  datas[left] = temp;
}

class AStep {
  static AStep done = AStep(type: AStepType.done);

  AStepType type;
  List<int>? idxs;
  List<num>? values;
  bool isShowMarked;
  dynamic value;

  AStep({this.type = AStepType.find, this.idxs, this.value, this.isShowMarked = false, this.values});

  @override
  String toString() => 'AStep(idxs: $idxs, isShowMarked: $isShowMarked, value: $value)';
}

enum AStepType { find, mark, swap, update, done, fillStart, fillOver, filling }
