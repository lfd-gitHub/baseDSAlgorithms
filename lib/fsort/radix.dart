import 'dart:math';

import 'package:jdsaa/base/algorithm.dart';
import 'package:jdsaa/fsort/insert/shell.dart';

class RadixSort with IAlgorithm {
  static final sTAG = (RadixSort).toString();

  static final RadixSort _singleton = RadixSort._internal();
  RadixSort._internal();

  factory RadixSort() => _singleton;

  @override
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) async* {
    log("[$sTAG] ");
    //① 最大位数
    num maxValue = datas[from];
    for (var item in datas) {
      if (maxValue < item) maxValue = item;
    }
    int maxBit = "$maxValue".length;
    var bucket = List.generate(10, (index) => []);
    for (var i = 1, n = 1; i <= maxBit; i++, n *= 10) {
      log("[$sTAG] start push bit of $i / $n");

      for (var j = from; j < to; j++) {
        var value = datas[j];
        var valueOfbit = value.toInt() ~/ n % 10;
        log("[$sTAG] $value of bit $valueOfbit");
        bucket[valueOfbit].add(value);
      }
      log("[$sTAG] bit of $i pushed | $bucket");
      int m = 0;
      for (var j = 0; j < bucket.length; j++) {
        int len = bucket[j].length;
        for (var k = 0; k < len; k++) {
          datas[m++] = bucket[j].removeAt(0);
        }
      }

      log("[$sTAG] bit of $i refilled | $datas");
    }

    yield AStep.done;
  }
}

void main(List<String> args) async {
  var list = List.generate(20, (i) => Random().nextInt(100000)); //[0, 100, 10, 5, 2000, 1, 55];
  log("before = $list");
  var ss = RadixSort().sort(list);
  await for (var _ in ss) {}
  log("result = $list");
}
