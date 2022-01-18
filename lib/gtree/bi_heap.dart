import 'dart:math';

import 'package:jdsaa/fsort/swap/quick.dart';
import 'package:jdsaa/gtree/bi_tree.dart';
import 'package:jdsaa/gtree/tree_node.dart';

void main(List<String> args) {
  var arr = [8, 89, 50, 50, 49, 93, 29, 38, 34]; //List.generate(9, (index) => Random().nextInt(100));
  logd("arr = $arr");
  var heap = BiMaxHeap.from(arr);
  //heap.add(12);
  heap.convert().completeTreeShow();
  var max = heap.removeMax();
  logd("remove max = $max");
  heap.convert().completeTreeShow();
}

class BiMaxHeap<T extends Comparable> {
  final List<T> _datas = [];

  static BiMaxHeap<T> from<T extends Comparable>(List<T> datas) {
    var tree = BiMaxHeap<T>();
    for (var element in datas) {
      tree.add(element);
    }
    return tree;
  }

  int getParentIndex(int index) => (index - 1) ~/ 2;
  int getLeftChildIndex(int index) => index * 2 + 1;
  int getRightChildIndex(int index) => index * 2 + 2;

  BiTree<T> convert() {
    var tree = BiTree<T>();
    tree.root = TreeNode(value: _datas[0]);
    var nodes = [tree.root!];
    var idx = 0;
    var altitude = log(_datas.length) ~/ log(2) + 1;
    logd("altitude = $altitude");
    while (altitude-- > 0) {
      logd("nodes = $nodes");
      nodes = nodes
          .expand((e) => [
                if (idx + 1 < _datas.length) e.leftNode = TreeNode(value: _datas[++idx]),
                if (idx + 1 < _datas.length) e.rightNode = TreeNode(value: _datas[++idx]),
              ])
          .toList();
    }
    return tree;
  }

  int add(T value) {
    int idx = _datas.length;
    _datas.add(value);
    T curValue;
    T parentValue;
    do {
      curValue = _datas[idx];
      int parentIdx = getParentIndex(idx);
      parentValue = _datas[parentIdx];
      if (curValue.compareTo(parentValue) < 0) {
        break;
      }
      _datas[parentIdx] = _datas[idx];
      _datas[idx] = parentValue;
      idx = parentIdx;
    } while (idx > 0);
    return idx;
  }

  T getAt(int index) {
    return _datas[index];
  }

  void swap(List<T> datas, int from, int to) {
    var temp = datas[from];
    datas[from] = datas[to];
    datas[to] = temp;
  }

  T removeMax() {
    if (isEmpty) throw "heap is empty";
    var max = _datas.removeAt(0);
    _datas.insert(0, _datas.removeLast());
    var idx = 0;
    var dLen = _datas.length;
    while (true) {
      var curValue = _datas[idx];
      var childLeftIndex = getLeftChildIndex(idx);
      var childRightIndex = getRightChildIndex(idx);
      T? childLeftValue = childLeftIndex < dLen ? _datas[childLeftIndex] : null;
      T? childRightValue = childRightIndex < dLen ? _datas[childRightIndex] : null;

      if (childLeftValue != null) {
        if (childLeftValue.compareTo(curValue) > 0) {
          if (childLeftValue.compareTo(childRightValue ?? childLeftValue) >= 0) {
            //left > parent && (left >= right || right == null);
            swap(_datas, idx, childLeftIndex);
            idx = childLeftIndex;
            continue;
          }
        }
      }

      if (childRightValue != null) {
        if (childRightValue.compareTo(curValue) > 0) {
          //right > parent
          swap(_datas, idx, childRightIndex);
          idx = childRightIndex;
          continue;
        }
      }

      break;
    }
    return max;
  }

  T getParentAt(int index) {
    if (index == 0) throw "index 0 is root";
    return _datas[getParentIndex(index)];
  }

  T getLeftChildAt(int index) {
    var idx = getLeftChildIndex(index);
    if (idx < _datas.length) {
      return _datas[idx];
    }
    throw "out of heap";
  }

  T getRightChildAt(int index) {
    var idx = getRightChildIndex(index);
    if (idx < _datas.length) {
      return _datas[idx];
    }
    throw "out of heap";
  }

  T get max => isEmpty ? throw "heap is empty" : _datas.first;
  int get size => _datas.length;
  bool get isEmpty => _datas.isEmpty;
}
