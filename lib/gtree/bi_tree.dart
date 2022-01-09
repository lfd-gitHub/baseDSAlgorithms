import 'dart:io';

import 'package:jdsaa/fsort/insert/shell.dart';
import 'package:jdsaa/gtree/tree_node.dart';

class BiTree<T> {
  TreeNode<T>? root;

  bool isEmpty() => root == null;

  void nlrShow() {
    root?.nlrShow();
    stdout.writeln();
  }

  void lnrShow() {
    root?.lnrShow();
    stdout.writeln();
  }

  void lrnShow() {
    root?.lrnShow();
    stdout.writeln();
  }

  TreeNode<T>? findByNLR(T target) {
    return root?.findByNLR(target);
  }

  TreeNode<T>? findByLNR(T target) {
    return root?.findByLNR(target);
  }

  TreeNode<T>? findByLRN(T target) {
    return root?.findByLRN(target);
  }

  TreeNode<T>? delByNLR(T target) {
    if (root?.value == target) {
      var _r = root;
      root = null;
      return _r;
    }
    return root?.deleteByNLR(target);
  }
}

void main(List<String> args) async {
  BiTree<int> biTree = BiTree<int>();
  biTree.root = TreeNode(value: 1);

  biTree.root!.leftNode = TreeNode(value: 2);
  biTree.root!.leftNode!.leftNode = TreeNode(value: 4);
  biTree.root!.leftNode!.rightNode = TreeNode(value: 5);

  biTree.root!.rightNode = TreeNode(value: 3);
  biTree.root!.rightNode!.leftNode = TreeNode(value: 6);
  biTree.root!.rightNode!.rightNode = TreeNode(value: 7);

  biTree.nlrShow();
  log("-----");
  biTree.lnrShow();
  log("-------");
  biTree.lrnShow();

  log("--------find5------");
  log(biTree.findByNLR(5)?.toString() ?? "not found");
  log("--------find5------");
  log(biTree.findByLNR(5)?.toString() ?? "not found");
  log("--------find5------");
  log(biTree.findByLRN(5)?.toString() ?? "not found");

  log("--------del5------");
  biTree.delByNLR(5);
  biTree.nlrShow();
  TreeNode? r = biTree.delByNLR(10);
  log("del 10 ? $r");
  log("--------del1------");
  biTree.delByNLR(1);
  biTree.nlrShow();
}
