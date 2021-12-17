// ignore_for_file: avoid_print

import 'package:jdsaa/base/algorithm.dart';

class BiSearch with IAlgorithm {
  static final BiSearch _singleton = BiSearch._internal();
  BiSearch._internal();

  factory BiSearch() => _singleton;

  @override
  Stream<AStep> find(List<num> datas, num target) async* {
    if (datas.isEmpty == true) throw "datas is empty";
    int idxBegin = 0;
    int idxEnd = datas.length - 1;
    int idxCenter = (idxEnd + idxBegin) ~/ 2;

    while (true) {
      var cData = datas[idxCenter];
      if (cData == target) {
        yield AStep(type: AStepType.done, value: idxCenter, idxs: [idxCenter]);
        return;
      } else {
        yield AStep(idxs: [idxBegin, idxCenter, idxEnd]);
      }
      if (cData > target) {
        idxEnd = idxCenter - 1;
      } else {
        idxBegin = idxCenter + 1;
      }
      if (idxBegin > idxEnd) {
        yield AStep(type: AStepType.done, value: -1, idxs: [-1]);
        return;
      }
      idxCenter = (idxEnd + idxBegin) ~/ 2;
    }
  }
}

void main(List<String> args) async {
  var search = BiSearch();
  //二分查找有序数列
  var list = List.generate(10, (index) => index * 1 + 5.0);
  print(list);
  print("[Find] biSearch -1 = ${await search.find(list, -1).last}");
  print("[Find] biSearch 5 = ${await search.find(list, 5).last}");
  print("[Find] biSearch 7 = ${await search.find(list, 7).last}");
  print("[Find] biSearch 14 = ${await search.find(list, 14).last}");

  List<num> nums = List.generate(10, (index) => index);
  num r = nums.reduce((value, element) => value > element ? element : value);
  print("r = $r");
}
