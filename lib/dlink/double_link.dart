// ignore_for_file: avoid_print

///双向循环链表
class DoubleLink<T> {
  int size = 0;
  DNode<T>? head;

  void insertAt(int pos, T data) {
    var node = DNode(data);
    if (head == null) {
      head = node;
      size++;
    } else {
      int index = 0;
      var pre = head?.pre;
      var cur = head;
      do {
        if (index == pos) {
          pre!.next = node;
          node.pre = pre;
          node.next = cur!;
          cur.pre = node;
          size++;
          break;
        }
        pre = cur;
        cur = cur!.next;
      } while (index++ != pos);
    }
  }

  T removeAt(int pos) {
    if (head != null) {
      int index = 0;
      DNode<T> pre = head!.pre;
      DNode<T> cur = head!;
      do {
        if (index == pos) {
          if (size == 1) {
            head = null;
            size = 0;
            return cur.value;
          } else {
            T value = cur.value;
            if (index == 0) head = cur.next;
            pre.next = cur.next;
            cur.next.pre = pre;
            size--;
            return value;
          }
        }
        pre = cur;
        cur = cur.next;
      } while (index++ != pos && index < size);
    }
    throw Exception("out of range!");
  }

  void show() {
    if (head == null) return;
    DNode<T> pre = head!.pre;
    DNode<T> cur = head!;
    StringBuffer sbuffer = StringBuffer();
    sbuffer.write("link : ");
    sbuffer.write("[");
    sbuffer.write(cur.value);
    sbuffer.write("]");
    while (cur.next != head) {
      pre = cur;
      cur = cur.next;
      if (cur.pre == pre && pre.next == cur) {
        sbuffer.write("<");
      }
      sbuffer.write("->[");
      sbuffer.write(cur.value);
      sbuffer.write("]");
    }
    print(sbuffer);
  }
}

void main() {
  var dl = DoubleLink<int>();
  print("insert 0=1, 1=2, 2=3");
  dl.insertAt(0, 1);
  dl.insertAt(1, 2);
  dl.insertAt(2, 3);
  dl.show();
  print("size = ${dl.size}");
  print("remove at 0 => ${dl.removeAt(0)}");
  dl.show();
  print("remove at 1 => ${dl.removeAt(1)}");
  dl.show();
  print("remove at 0 => ${dl.removeAt(0)}");
  dl.show();
}

class DNode<T> {
  late T _value;
  late DNode<T> pre;
  late DNode<T> next;

  DNode(T value) {
    _value = value;
    pre = this;
    next = this;
  }

  T get value => _value;
}
