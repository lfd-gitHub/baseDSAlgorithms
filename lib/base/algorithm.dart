///
///
///
abstract class IAlgorithm {
  Stream<AStep> find(List<num> datas, num target) => throw 'not implement';
  Stream<AStep> sort(List<num> datas) => throw 'not implement';
}

class AStep {
  AStepType type;
  List<int>? idxs;
  bool isExchagne;
  dynamic value;

  AStep({this.type = AStepType.find, this.idxs, this.isExchagne = false, this.value});

  @override
  String toString() => 'AStep(type: $type ,idxs: $idxs, isExchagne: $isExchagne, value: $value)';
}

enum AStepType { find, exchange, result }
