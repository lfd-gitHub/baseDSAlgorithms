import 'dart:io';
import 'dart:math';

import 'package:jdsaa/base/algorithm.dart';
import 'package:jdsaa/gtree/tree_node.dart';

class BiTree<T> {
  TreeNode<T>? root;

  bool isEmpty() => root == null;

  static BiTree<T> oriConvert<T>(List<T> datas) {
    var tree = BiTree<T>();
    tree.root = TreeNode(value: datas[0]);
    var nodes = [tree.root!];
    var idx = 0;
    var altitude = log(datas.length) ~/ log(2) + 1;
    //logd("altitude = $altitude");
    while (altitude-- > 0) {
      //logd("nodes = $nodes");
      nodes = nodes
          .expand((e) => [
                if (idx + 1 < datas.length) e.leftNode = TreeNode(value: datas[++idx]),
                if (idx + 1 < datas.length) e.rightNode = TreeNode(value: datas[++idx]),
              ])
          .toList();
    }
    return tree;
  }

  void completeTreeShow() {
    if (root == null) {
      logd("empty true");
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
    //logd("{max : $altitude ,maxSlen : $maxSlen , maxValueLen : $maxValueLen , holderSlen : $holderSlen}");
    //logd("-------------------------");
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
    logd("-------------------------");
  }

  ///?????????????????????
  int _maxValueSLen(int altitude) {
    return "${pow(2, altitude).toInt() - 2}".length;
  }

  ///-09- = 4
  int _holderSLen(int altitude) => _maxValueSLen(altitude) + 2;

  ///?????????????????????????????????
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

  logd("========complete show=========");
  biTree.completeTreeShow();
  logd("========complete show=========");

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
