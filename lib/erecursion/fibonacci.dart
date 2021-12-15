// ignore_for_file: avoid_print

class Fibonacci {
  static int fib(int n) {
    if (n <= 2) return n - 1;
    return fib(n - 1) + fib(n - 2);
  }
}

void main(List<String> args) {
  print(List.generate(20, (index) => Fibonacci.fib(index + 1)).join(" -> "));
}
