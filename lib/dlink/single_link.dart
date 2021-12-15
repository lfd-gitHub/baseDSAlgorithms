// ignore_for_file: avoid_print

class SingleLink<T> with Iterator<T> {
  SNode<T>? _root;
  int _size = 0;

  SingleLink();

  SingleLink<T> append(T data) {
    SNode<T> node = SNode(data);
    if (_root == null) {
      _root = node;
    } else {
      SNode cNode = _root!;
      while (cNode.next != null) {
        cNode = cNode.next!;
      }
      cNode.next = node;
    }
    _size++;
    return this;
  }

  int get size => _size;
  SNode<T>? _currentNode;

  Iterator<T> iterator() {
    _currentNode = _root;
    return this;
  }

  @override
  T get current {
    if (_currentNode == null) {
      throw "out of range";
    }
    T value = _currentNode!.value()!;
    _currentNode = _currentNode!.next;
    return value;
  }

  @override
  bool moveNext() {
    return _currentNode != null;
  }

  T getAt(int index) {
    if (index > size) {
      throw "index out of range";
    }
    var current = _root;
    int _index = 0;
    while (current != null) {
      if (_index == index) return current.value();
      current = current.next;
      _index++;
    }
    throw "index out of range";
  }

  void insertAt(int index, T data) {
    if (index > size) {
      throw "index out of range";
    }
    if (index == size) {
      append(data);
      return;
    }
    SNode<T>? pre;
    var current = _root;
    int _index = 0;
    SNode<T> sNode = SNode<T>(data);
    while (current != null) {
      if (_index == index) {
        sNode.next = current;
        if (pre == null) {
          _root = sNode;
        } else {
          pre.next = sNode;
        }
        _size++;
        return;
      }
      pre = current;
      current = current.next;
      _index++;
    }
  }

  T delete(T data) {
    SNode<T>? pre;
    var cur = _root;
    while (cur != null) {
      T value = cur.value();
      if (value == data) {
        if (pre == null) {
          _root = cur.next;
        } else {
          pre.next = cur.next;
        }
        _size--;
        return cur.value();
      }
    }

    throw "not found";
  }

  void show() {
    if (_root == null) return;
    var cNext = _root!.next;
    StringBuffer sBuffer = StringBuffer();
    sBuffer.write("[");
    sBuffer.write(_root!.value());
    sBuffer.write("]");
    while (cNext != null) {
      sBuffer.write("->");
      sBuffer.write("[");
      sBuffer.write(cNext.data);
      sBuffer.write("]");
      cNext = cNext.next;
    }
    print(sBuffer);
  }
}

void main() {
  SingleLink<String> link = SingleLink<String>();
  print("---------append a b c------------");
  link.append("a").append("b").append("c");
  link.show();
  print("---------delete a b c------------");
  link.delete("a");
  link.delete("b");
  link.delete("c");
  //link.delete("d");
  print("size = ${link.size}");
  link.show();
  print("---------insert at 0 = 10 & 0 =20 ------------");
  link.insertAt(0, "10");
  link.insertAt(0, "20");
  link.show();
  print("size = ${link.size}");
  print("-----------for----------");
  for (int i = 0; i < link.size; i++) {
    print("$i = ${link.getAt(i)}");
  }
  print("-----------iterator----------");
  Iterator<String> it = link.iterator();
  while (it.moveNext()) {
    print("it next => ${it.current}");
  }
  print("-----------again----------");
  it = link.iterator();
  while (it.moveNext()) {
    print("it next => ${it.current}");
  }

  it.current;
}

class SNode<D> {
  D data;
  SNode<D>? next;

  SNode(this.data);

  D value() {
    return data;
  }
}
