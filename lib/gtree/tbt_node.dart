import 'dart:io';

class TbtNode<T> {
  bool isThreadedLeft;
  bool isThreadedRight;
  final T value;
  TbtNode? leftNode;
  TbtNode? rightNode;

  TbtNode({
    required this.value,
    this.isThreadedLeft = false,
    this.isThreadedRight = false,
    this.leftNode,
    this.rightNode,
  });

  void lnrShow() {
    if (!isThreadedLeft) leftNode?.lnrShow();
    stdout.writeln("${leftNode?.value} <- [$value] -> ${rightNode?.value}");
    if (!isThreadedRight) rightNode?.lnrShow();
  }
}
