// ignore_for_file: avoid_print
//栈
class Stack<T> {
  List<T> es = [];

  void push(T e) {
    es.add(e);
  }

  T pop() {
    return es.removeLast();
  }

  T peek() {
    return es.last;
  }

  bool isEmpty() {
    return es.isEmpty;
  }
}

void main(List<String> args) {
  Stack s = Stack();
  s.push(1);
  s.push(2);
  print("${s.pop()} ： ${s.peek()}");
  print("${s.pop()} ： ${s.peek()}");
  print("${s.pop()} ： ${s.peek()}");
}
