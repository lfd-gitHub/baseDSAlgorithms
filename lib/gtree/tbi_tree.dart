import 'package:jdsaa/fsort/insert/shell.dart';
import 'package:jdsaa/gtree/bi_tree.dart';
import 'package:jdsaa/gtree/tbt_node.dart';
import 'package:jdsaa/gtree/tree_node.dart';

class TbiTree<T> {
  TbtNode<T> root;
  TbiTree({
    required this.root,
  });

  static TbiTree<T> from<T>(TreeNode<T> node) {
    return TbiTree<T>(root: node.toTbt());
  }

  void lnrShow() {
    root.lnrShow();
  }

  void threadedLNRNodes() {
    _threadedLNRNodes(root);
  }

  TbtNode? _tempThreadedNode;
  void _threadedLNRNodes(TbtNode node) {
    if (node.leftNode != null && node.isThreadedLeft == false) {
      _threadedLNRNodes(node.leftNode!);
    }

    if (_tempThreadedNode != null) {
      if (node.leftNode == null) {
        node.leftNode = _tempThreadedNode;
        node.isThreadedLeft = true;
      }

      if (_tempThreadedNode!.rightNode == null) {
        _tempThreadedNode!.rightNode = node;
        _tempThreadedNode!.isThreadedRight = true;
      }
    }

    _tempThreadedNode = node;
    if (node.rightNode != null && node.isThreadedRight == false) {
      _threadedLNRNodes(node.rightNode!);
    }
  }
}

void main(List<String> args) {
  BiTree<int> biTree = BiTree.genPerfectTree(3);
  biTree.completeTreeShow();
  log("==============");
  TbiTree<int> tree = TbiTree.from(biTree.root!);
  tree.lnrShow();
  log("==============");
  tree.threadedLNRNodes();
  log("==============");
  tree.lnrShow();
}
