import 'dart:io';
import 'dart:math';

import 'package:jdsaa/fsort/insert/shell.dart';
import 'package:jdsaa/gtree/tree_node.dart';

class BiTree<T> {
  TreeNode<T>? root;

  bool isEmpty() => root == null;

  void completeTreeShow() {
    if (root == null) {
      log("empty true");
      return;
    }
    List<TreeNode> leftNodes = [];
    TreeNode<T>? n = root;
    while (n != null) {
      leftNodes.add(n);
      n = n.leftNode;
    }
    var altitude = leftNodes.length;
    List<TreeNode<T>> parents = <TreeNode<T>>[root!];
    int maxValueLen = _maxValueSLen(altitude);
    int maxSlen = _maxSpaceLen(altitude);
    int holderSlen = _holderSLen(altitude);
    String endJoinStr = maxValueLen % 2 == 0 ? "" : "+";
    log("{max : $altitude ,maxSlen : $maxSlen , maxValueLen : $maxValueLen , holderSlen : $holderSlen}");
    log("-------------------------");
    for (var h = 0; h < altitude; h++) {
      var layerValueCount = pow(2, h).toInt();
      var perSpaceSLen = (maxSlen - layerValueCount * holderSlen) / layerValueCount;
      //log("{layerValueCount: $layerValueCount, perSpaceSLen: $perSpaceSLen}");
      if (h < altitude - 1) {
        stdout.write(" " * (perSpaceSLen ~/ 2));
        stdout.write(parents
            .map((e) => " ${e.value.toString().padLeft(maxValueLen, '0')} ") //
            .join(" " * perSpaceSLen.ceil()));
        stdout.writeln();
        stdout.write(" " * (perSpaceSLen ~/ 2));
        stdout.write(parents
            .map((e) => "/${" " * e.value.toString().padLeft(maxValueLen, '0').length}\\") //
            .join(" " * perSpaceSLen.ceil()));
        stdout.writeln();
      } else {
        stdout.writeln(parents
            .map((e) => "-${e.value.toString().padLeft(maxValueLen, '0')}-") //
            .join(endJoinStr));
      }
      parents = parents
          .expand((e) => [e.leftNode, e.rightNode])
          .where((e) => e != null) //
          .map((e) => e!)
          .toList();
    }
    log("-------------------------");
  }

  ///最大数值的位数
  int _maxValueSLen(int altitude) {
    return "${pow(2, altitude).toInt() - 2}".length;
  }

  ///-09- = 4
  int _holderSLen(int altitude) => _maxValueSLen(altitude) + 2;

  ///完美树叶子节点字符长度
  int _maxSpaceLen(int altitude) {
    int holderSLen = _holderSLen(altitude);
    int maxSlen = pow(2, altitude - 1).toInt();

    ///eg:-09--10- | -1-+-2-
    maxSlen = maxSlen * holderSLen + (holderSLen % 2 == 0 ? 0 : (maxSlen - 1));
    return maxSlen;
  }

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

  static BiTree<int> genPerfectTree(int altitude) {
    var tree = BiTree<int>();
    tree.root = TreeNode<int>(value: 0);
    var parents = <TreeNode<int>>[tree.root!];
    for (var i = 0; i < altitude - 1; i++) {
      int startValue = pow(2, i + 1).toInt() - 1;
      parents = parents
          .map((e) {
            e.leftNode = TreeNode(value: startValue++);
            e.rightNode = TreeNode(value: startValue++);
            return e;
          })
          .expand((e) => [e.leftNode!, e.rightNode!])
          .toList();
    }
    return tree;
  }
}

void main(List<String> args) async {
  var biTree = BiTree.genPerfectTree(4);

  log("========complete show=========");
  biTree.completeTreeShow();
  log("========complete show=========");

  // biTree.nlrShow();
  // log("-----");
  // biTree.lnrShow();
  // log("-------");
  // biTree.lrnShow();

  // log("--------find5------");
  // log(biTree.findByNLR(5)?.toString() ?? "not found");
  // log("--------find5------");
  // log(biTree.findByLNR(5)?.toString() ?? "not found");
  // log("--------find5------");
  // log(biTree.findByLRN(5)?.toString() ?? "not found");

  // log("--------del5------");
  // biTree.delByNLR(5);
  // biTree.nlrShow();
  // TreeNode? r = biTree.delByNLR(10);
  // log("del 10 ? $r");
  // log("--------del1------");
  // biTree.delByNLR(1);
  // biTree.nlrShow();
}
