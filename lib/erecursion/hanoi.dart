///汉诺塔递归移动
///将[count]个圆盘通过[from]柱子借助[by]柱子移动到[to]柱子上
// ignore_for_file: avoid_print

Stream<HanoiStep> hanoi(int count, String from, String by, String to) async* {
  if (count <= 1) {
    await Future.delayed(const Duration(seconds: 1));
    yield HanoiStep(count, from, to);
    return;
  }

  //非最后一个都移到第二个柱子上
  yield* hanoi(count - 1, from, to, by);

  await Future.delayed(const Duration(seconds: 1));
  //最后一个移动到第三个柱子上
  yield HanoiStep(count, from, to);

  //再移动第二柱子上所有到地三个柱子上
  yield* hanoi(count - 1, by, from, to);
}

class HanoiStep {
  int index;
  String from;
  String to;

  HanoiStep(this.index, this.from, this.to);

  @override
  String toString() => 'HanoiStep(index: $index, from: $from, to: $to)';
}

void main(List<String> args) {
  Future(() {
    var s = hanoi(3, 'A', 'B', 'C');
    s.listen((event) => print(event));
  });
}
