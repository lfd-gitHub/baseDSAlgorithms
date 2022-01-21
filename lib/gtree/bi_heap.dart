import 'package:jdsaa/fsort/swap/quick.dart';
import 'package:jdsaa/gtree/bi_tree.dart';

void main(List<String> args) {
  var arr = [8, 89, 91, 92, 93]; //List.generate(9, (index) => Random().nextInt(100));
  logd("arr = $arr");
  var heap = BiMaxHeap.from(arr);
  //heap.add(12);
  heap.convert().completeTreeShow();
  // var max = heap.removeMax();
  // logd("remove max = $max");
  // heap.convert().completeTreeShow();
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

  static int getParentIndex(int index) => (index - 1) ~/ 2;
  static int getLeftChildIndex(int index) => index * 2 + 1;
  static int getRightChildIndex(int index) => index * 2 + 2;

  BiTree<T> convert() {
    return BiTree.oriConvert(_datas);
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

  static void swap<T>(List<T> datas, int from, int to) {
    var temp = datas[from];
    datas[from] = datas[to];
    datas[to] = temp;
  }

  T removeMax() {
    if (isEmpty) throw "heap is empty";
    var max = _datas.removeAt(0);
    if (isEmpty) return max;
    _datas.insert(0, _datas.removeLast());
    var idx = 0;
    var dLen = _datas.length;
    while (true) {
      var curValue = _datas[idx];
      var childLeftIndex = getLeftChildIndex(idx);
      var childRightIndex = getRightChildIndex(idx);

      var maxIndex = idx;
      if (childLeftIndex < dLen && _datas[childLeftIndex].compareTo(curValue) > 0) {
        maxIndex = childLeftIndex;
      }

      if (childRightIndex < dLen && _datas[childRightIndex].compareTo(_datas[maxIndex]) > 0) {
        maxIndex = childRightIndex;
      }

      if (maxIndex != idx) {
        swap(_datas, idx, maxIndex);
        idx = maxIndex;
        continue;
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
