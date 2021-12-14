///
///
///
abstract class IAlgorithmFind {
  Future<int> find(List<num> datas, num target, [StepCallBack? callBack]);
}

typedef StepCallBack = Future<void> Function(AStep step);

class AStep {
  AStepType type;
  List<int> idxs;
  bool isExchagne;

  AStep({
    this.type = AStepType.find,
    required this.idxs,
    this.isExchagne = false,
  });

  @override
  String toString() => 'AStep(idxs: $idxs, isExchagne: $isExchagne)';
}

enum AStepType { find, exchange }
