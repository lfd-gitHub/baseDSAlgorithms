import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jdsaa/erecursion/hanoi.dart';

class AnimHanoiPage extends StatefulWidget {
  const AnimHanoiPage({Key? key}) : super(key: key);

  @override
  State<AnimHanoiPage> createState() => _AnimHanoiState();
}

class _AnimHanoiState extends State<AnimHanoiPage> {
  List<Color> colors = [
    Colors.blue.shade400,
    Colors.pink.shade400,
    Colors.yellow.shade400,
    Colors.red.shade200,
    Colors.green.shade300,
    Colors.indigo.shade300,
    Colors.lime.shade300
  ];

  List<List> hanoiDisks = [[], [], []];

  final bottomAreaHeight = 80.0;
  final pillerMTopPortal = 150.0;
  final pillerMTopLand = 50.0;
  final pillerWidth = 30.0;

  final diskIncreUnit = 12.0;
  final diskMinWidth = 50.0;
  final diskHeight = 20.0;

  int count = 5;

  @override
  void initState() {
    reset();
    super.initState();
  }

  void reset() {
    hanoiDisks
      ..clear()
      ..add([])
      ..add([])
      ..add([])
      ..elementAt(0).addAll(List.generate(count, (index) => index + 1));
  }

  void move(HanoiStep s) async {
    int aChar = 'A'.codeUnits.first;
    int idxFrom = s.from.codeUnits.first - aChar;
    int idxTo = s.to.codeUnits.first - aChar;
    log("[AHanoi] pre $idxFrom -> $idxTo | ${s.to} | $s | $hanoiDisks");
    int idxWhat = hanoiDisks[idxFrom].removeAt(0);
    hanoiDisks[idxTo].insert(0, idxWhat);
    log("[AHanoi] move change - $hanoiDisks");
    setState(() {});
  }

  Stream<HanoiStep>? stream;
  StreamSubscription<HanoiStep>? subscription;

  void hanoiMove() async {
    if (subscription == null) {
      reset();
      stream = hanoi(count, 'A', 'B', 'C');
      subscription = stream?.asBroadcastStream().listen(move, onDone: close, onError: (e) {
        close();
      }, cancelOnError: true);
    } else {
      close();
      setState(() {
        reset();
      });
    }
  }

  void close() {
    //stream?.listen(null);
    subscription?.cancel();
    subscription = null;
    stream = null;
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hanoi")),
      body: SafeArea(
        top: false,
        bottom: true,
        child: _buildHanoiArea(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          hanoiMove();
        },
        child: Icon(stream == null ? Icons.play_circle_outline : Icons.stop_circle_outlined),
      ),
    );
  }

  Widget _buildHanoiArea() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(color: Colors.indigo.shade200, borderRadius: BorderRadius.circular(8.0)),
      child: LayoutBuilder(
        builder: (ctx, box) {
          bool isPor = MediaQuery.of(context).orientation == Orientation.portrait;
          //double perPillerSpaceX = box.maxWidth / 3;
          double pillerTop = isPor ? pillerMTopPortal : pillerMTopLand;
          log("[AHanoi] box $box");
          return Row(
            children: [
              for (var i = 0; i < hanoiDisks.length; i++)
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blue[i * 100],
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: pillerTop),
                            color: Colors.blueAccent,
                            width: pillerWidth,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: hanoiDisks[i].map((e) => _buildDisk(e)).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }

  Widget _buildDisk(int lev) {
    var child = Container(
      key: ValueKey(lev),
      color: colors[lev % colors.length],
      width: lev * diskIncreUnit + diskMinWidth,
      height: diskHeight,
      child: Center(child: Text("$lev", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white))),
    );

    // return AnimatedSwitcher(
    //     duration: const Duration(seconds: 1),
    //     transitionBuilder: (child, anim) {
    //       log("[AHanoi] ck = ${child.key}");
    //       return SlideTransition(
    //         position: anim.drive(Tween(begin: Offset(0, -1), end: Offset(0, 0))),
    //         child: child,
    //       );
    //     },
    //     child: child);
    return child;
  }
}
