// ignore_for_file: avoid_print

import 'package:jdsaa/base/algorithm.dart';

class BiSearch implements IAlgorithmFind {
  @override
  Future<int> find(List<num> datas, num target, [StepCallBack? callBack]) async {
    if (datas.isEmpty == true) return -1;
    int idxBegin = 0;
    int idxEnd = datas.length - 1;
    int idxCenter = (idxEnd + idxBegin) ~/ 2;

    while (true) {
      await callBack?.call(AStep(idxs: [idxBegin, idxCenter, idxEnd]));
      var cData = datas[idxCenter];
      if (cData == target) {
        return idxCenter;
      }
      if (cData > target) {
        idxEnd = idxCenter - 1;
      } else {
        idxBegin = idxCenter + 1;
      }
      if (idxBegin > idxEnd) {
        return -1;
      }
      idxCenter = (idxEnd + idxBegin) ~/ 2;
    }
  }
}

void main(List<String> args) {
  var search = BiSearch();
  //二分查找有序数列
  var list = List.generate(10, (index) => index * 1 + 5.0);
  print(list);
  print("[Find] biSearch -1 = ${search.find(list, -1)}");
  print("[Find] biSearch 5 = ${search.find(list, 5)}");
  print("[Find] biSearch 7 = ${search.find(list, 7)}");
  print("[Find] biSearch 14 = ${search.find(list, 14)}");

  List<num> nums = List.generate(10, (index) => index);
  num r = nums.reduce((value, element) => value > element ? element : value);
  print("r = $r");
}
