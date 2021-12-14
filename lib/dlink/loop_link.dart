// ignore_for_file: avoid_print

class LoopLink<T> {
  LNode<T>? _head;
  int _size = 0;

  LoopLink<T> addFirst(T data) {
    LNode<T> node = LNode<T>(data);
    LNode<T> _last = last;

    _last.next = node;
    node.next = _head;
    _head = node;

    _size++;
    return this;
  }

  LoopLink<T> appendLast(T data) {
    var node = LNode(data);
    if (isEmpty()) {
      _head = node;
      _head?.next = _head;
    } else {
      LNode<T> _last = last;
      _last.next = node;
      node.next = _head;
    }
    _size++;
    return this;
  }

  T removeAt(int pos) {
    if (_head == null) throw Exception("node non-existent");
    var _last = last;
    var _pre = last;
    var _cur = _head;
    int index = 0;
    do {
      if (index == pos) {
        if (_cur == _head) {
          if (size == 1) {
            _head = null;
          } else {
            _head = _head?.next;
            _last.next = _head;
          }
        } else {
          _pre.next = _cur?.next;
        }
        _size--;
        return _cur!.value;
      }
      _pre = _cur!;
      _cur = _cur.next;
    } while (index++ != pos);
    throw Exception("node non-existent");
  }

  void insertAt(int pos, T data) {
    if (pos < 0) pos = 0;
    if (pos > size) pos = size;
    int idx = 0;
    var node = LNode(data);
    if (isEmpty()) {
      appendLast(data);
      return;
    }
    var pre = last;
    var cur = _head;
    while (idx <= size) {
      if (idx == pos) {
        pre.next = node;
        node.next = cur;
        _size++;
        return;
      }
      idx++;
      pre = cur!;
      cur = cur.next;
    }
  }

  T remove(T data) {
    if (_head == null) throw Exception("node non-existent");
    var _last = last;
    var _pre = last;
    var cur = _head;
    do {
      if (cur?.value == data || cur?.value == data) {
        if (cur == _head) {
          if (size == 1) {
            _head = null;
          } else {
            _head = _head?.next;
            _last.next = _head;
          }
        } else {
          _pre.next = cur?.next;
        }
        _size--;
        return data;
      }
      _pre = cur!;
      cur = cur.next;
    } while (cur != _head);
    throw Exception("node non-existent");
  }

  bool has(T data) {
    if (isEmpty()) return false;
    var cur = _head;
    do {
      if (cur?.value == data || cur?.value == data) {
        return true;
      }
      cur = cur?.next;
    } while (cur != _head);
    return false;
  }

  int get size => _size;

  bool isEmpty() {
    return _head == null;
  }

  LNode<T> get first {
    if (_head == null) throw Exception("link is empty");
    return _head!;
  }

  LNode<T> get last {
    if (isEmpty()) {
      throw Exception("link is empty");
    }

    var cur = _head;
    while (cur?.next != _head) {
      cur = cur?.next;
    }
    return cur!;
  }

  void show() {
    if (_head == null) return;
    var cur = _head;
    StringBuffer sBuffer = StringBuffer();
    sBuffer.write("[");
    sBuffer.write(cur?.value);
    sBuffer.write("]");
    while (cur?.next != _head) {
      cur = cur?.next;
      sBuffer.write("->[");
      sBuffer.write(cur?.value);
      sBuffer.write("]");
    }
    print(sBuffer);
  }
}

void main() {
  var ll = LoopLink<int>();
  ll.insertAt(0, 1);
  ll.insertAt(100, 2);
  ll.addFirst(0);
  ll.appendLast(3);
  ll.show();
  print("first => ${ll.first.value}");
  print("last => ${ll.last.value}");
  print("isEmpty => ${ll.isEmpty}");
  print("size => ${ll.size}");
  print("has 3 => ${ll.has(3)}");
  print("has 2 => ${ll.has(2)}");
  print("has 0 => ${ll.has(0)}");
  ll.remove(2);
  ll.show();
  print("================");
  ll.remove(0);
  ll.show();
  print("================");
  ll.remove(3);
  ll.show();
  print("================");
  ll.remove(1);
  ll.show();
  print("isempty - ${ll.isEmpty()}");
  /////////////// 约瑟夫环 ////////////////////
  int n = 50; //5个人
  for (int i = 0; i < n; i++) {
    ll.appendLast(i + 1);
  }
  ll.show();
  int count = 3; //数到第3个人
  int idx = 0;
  while (!ll.isEmpty()) {
    idx += count;
    print("remove ${ll.removeAt(idx)}");
    //ll.show();
  }

  print("current size ${ll.size}");
  ll.show();
}

class LNode<T> {
  T data;
  LNode(this.data, [this.next]);
  LNode<T>? next;

  T get value => data;
}
