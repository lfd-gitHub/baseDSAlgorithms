import 'dart:io';

import 'package:jdsaa/gtree/tbt_node.dart';

class TreeNode<T> {
  T value;
  TreeNode<T>? leftNode;
  TreeNode<T>? rightNode;

  TreeNode({required this.value});

  TbtNode<T> toTbt() {
    TbtNode<T> tbtNode = TbtNode(value: value);
    tbtNode.leftNode = leftNode?.toTbt();
    tbtNode.rightNode = rightNode?.toTbt();
    return tbtNode;
  }

  void nlrShow() {
    stdout.write(" $value");
    leftNode?.nlrShow();
    rightNode?.nlrShow();
  }

  void lnrShow() {
    leftNode?.lnrShow();
    stdout.write(" $value");
    rightNode?.lnrShow();
  }

  void lrnShow() {
    leftNode?.lrnShow();
    rightNode?.lrnShow();
    stdout.write(" $value");
  }

  TreeNode<T>? findByNLR(T target) {
    if (value == target) {
      return this;
    }
    var leftResult = leftNode?.findByNLR(target);
    return leftResult ?? rightNode?.findByNLR(target);
  }

  TreeNode<T>? findByLNR(T target) {
    var result = leftNode?.findByLNR(target);
    result = result ?? (value == target ? this : null);
    return result ?? rightNode?.findByLNR(target);
  }

  TreeNode<T>? findByLRN(T target) {
    var result = leftNode?.findByLRN(target);
    result = result ?? rightNode?.findByLRN(target);
    result = result ?? (value == target ? this : null);
    return result;
  }

  TreeNode<T>? deleteByNLR(T target) {
    if (target == value) {
      return this;
    }
    if (leftNode?.value == target) {
      leftNode = null;
      return leftNode;
    }
    if (rightNode?.value == target) {
      rightNode = null;
      return rightNode;
    }
    return leftNode?.deleteByNLR(target) ?? rightNode?.deleteByNLR(target);
  }

  @override
  String toString() => 'TreeNode(value: $value)';
}
