///汉诺塔递归移动
///将[count]个圆盘通过[from]柱子借助[by]柱子移动到[to]柱子上
// ignore_for_file: avoid_print

Stream<HanoiStep> hanoi(int count, String from, String by, String to) async* {
  if (count <= 1) {
    yield HanoiStep(count, from, to);
    return;
  }

  //非最后一个都移到第二个柱子上
  yield* hanoi(count - 1, from, to, by);

  //最后一个移动到第三个柱子上
  yield HanoiStep(count, from, to);

  //再移动第二柱子上所有到地三个柱子上
  yield* hanoi(count - 1, by, from, to);
}

int aChar = 'A'.codeUnits.first;

class HanoiStep {
  late int dIndex;
  late int pFrom;
  late int pTo;

  HanoiStep(int index, String sPfrom, String sPto) {
    dIndex = index;
    pFrom = sPfrom.codeUnits[0] - aChar;
    pTo = sPto.codeUnits[0] - aChar;
  }

  @override
  String toString() => 'HanoiStep(index: $dIndex, from: $pFrom, to: $pTo)';
}

void main(List<String> args) {
  Future(() {
    var s = hanoi(3, 'A', 'B', 'C');
    s.listen((event) => print(event));
  });
}
