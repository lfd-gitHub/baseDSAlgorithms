// ignore_for_file: avoid_print
///队列
class Queue<T> {
  List<T> es = [];

  void add(T e) {
    es.add(e);
  }

  T poll() {
    return es.removeAt(0);
  }

  bool isEmpty() {
    return es.isEmpty;
  }
}

void main() {
  Queue queue = Queue();
  queue.add(1);
  queue.add(2);
  print("poll -> ${queue.poll()}");
  print("poll -> ${queue.poll()}");
}
