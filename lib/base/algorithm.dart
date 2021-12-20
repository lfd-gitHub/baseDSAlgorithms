///
///
///
abstract class IAlgorithm {
  Stream<AStep> find(List<num> datas, num target) => throw 'not implement';
  Stream<AStep> sort(List<num> datas) => throw 'not implement';
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) => throw 'not implement';
}

class AStep {
  static AStep done = AStep(type: AStepType.done);

  AStepType type;
  List<int>? idxs;
  bool isShowMarked;
  dynamic value;

  AStep({this.type = AStepType.find, this.idxs, this.value, this.isShowMarked = false});

  @override
  String toString() => 'AStep(idxs: $idxs, isShowMarked: $isShowMarked, value: $value)';
}

enum AStepType { find, mark, swap, update, done }
