///
///
///
abstract class IAlgorithm {
  Stream<AStep> find(List<num> datas, num target) => throw 'not implement';
  Stream<AStep> sort(List<num> datas) => throw 'not implement';
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) => throw 'not implement';
}

class AStep {
  AStepType type;
  List<int>? idxs;
  int? markIndex;
  bool isExchagne;
  dynamic value;

  AStep({this.type = AStepType.find, this.idxs, this.isExchagne = false, this.value, this.markIndex});

  @override
  String toString() {
    return 'AStep(type:$type,idxs: $idxs, markIndex: $markIndex, isExchagne: $isExchagne, value: $value)';
  }
}

enum AStepType { find, exchange, result, update }
