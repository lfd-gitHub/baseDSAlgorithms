import 'dart:math';

import 'package:jdsaa/base/algorithm.dart';
import 'package:jdsaa/gtree/bi_heap.dart';
import 'package:jdsaa/gtree/bi_tree.dart';

class HeapSort with IAlgorithm {
  // ignore: unused_element
  Stream<AStep> _simpleSort(List<num> datas, [int from = 0, int to = 0]) async* {
    BiMaxHeap<num> maxHeap = BiMaxHeap.from(datas.getRange(from, to).toList());
    for (var i = to - 1; i >= from; i--) {
      var value = maxHeap.removeMax();
      datas[i] = value;
      yield AStep(type: AStepType.update, idxs: [i], value: value);
    }
    yield AStep.done;
  }

  Stream<AStep> toMaxTree(List<num> datas, {int? length, int? pIndex}) async* {
    logd("[toMaxTree] begin to max tree ===");
    //get last parent node index
    var dLen = length ?? datas.length;
    BiTree.oriConvert(datas.getRange(0, dLen).toList()).completeTreeShow();
    var pidx = pIndex ?? BiMaxHeap.getParentIndex(dLen - 1);
    for (var i = pidx; i >= 0; i--) {
      var maxIdx = i;
      var maxValue = datas[maxIdx];
      var leftIdx = BiMaxHeap.getLeftChildIndex(maxIdx);
      var rightIdx = BiMaxHeap.getRightChildIndex(maxIdx);
      if (leftIdx < dLen && maxValue < datas[leftIdx]) {
        maxIdx = leftIdx;
      }
      if (rightIdx < dLen && maxValue < datas[rightIdx]) {
        maxIdx = rightIdx;
      }
      if (maxIdx != i) {
        logd("[toMaxTree] swap => $maxIdx -> $i");
        BiMaxHeap.swap(datas, i, maxIdx);
        yield AStep(type: AStepType.swap, idxs: [i, maxIdx]);
        //reorder children
        logd("[toMaxTree] start reorder children");
        yield* toMaxTree(datas, length: dLen, pIndex: maxIdx);
        logd("[toMaxTree] end reorder children");
      }
    }
    BiTree.oriConvert(datas.getRange(0, dLen).toList()).completeTreeShow();
    logd("[toMaxTree] end to max tree ===");
  }

  @override
  Stream<AStep> sortRange(List<num> datas, [int from = 0, int to = 0]) async* {
    //convert to max heap

    var sortDatas = datas.getRange(from, to).toList();

    logd("① start to convert max tree....");
    BiTree.oriConvert(sortDatas).completeTreeShow();
    yield* toMaxTree(sortDatas);
    BiTree.oriConvert(sortDatas).completeTreeShow();
    logd("① end to convert max tree.....");

    logd("② start move max to end...");
    for (var i = sortDatas.length - 1; i > 0; i--) {
      //move max to end
      logd("move max to end 0 -> $i | $sortDatas");
      BiMaxHeap.swap(sortDatas, 0, i);
      yield AStep(type: AStepType.swap, idxs: [0, i]);
      if (i > 1) {
        yield* toMaxTree(sortDatas, length: i);
      }
    }
    logd("② end move max to end...");
    datas.setRange(from, to, sortDatas);
    yield AStep.done;
  }
}

void main(List<String> args) async {
  var arr = List.generate(20, (index) => Random().nextInt(100));
  //var arr = [5, 2, 3, 7, 9];
  logd("---before:$arr");
  //HeapSort().sort(arr);
  var ss = HeapSort().sort(arr);
  // ignore: unused_local_variable
  await for (var item in ss) {}
  logd("---after:$arr");
}
