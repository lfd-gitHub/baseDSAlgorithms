import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jdsaa/views/widgets/data_widget.dart';

class DataSheet extends StatelessWidget {
  final List datas;

  const DataSheet({Key? key, required this.datas}) : super(key: key);

  static void show(BuildContext context, List datas) {
    //showBottomSheet(context: context, builder: (ctx) => DataSheet(datas: datas));
    showCupertinoModalPopup(context: context, builder: (ctx) => DataSheet(datas: datas));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Spacer(flex: 1),
      Expanded(
        flex: 2,
        child: Scaffold(
          body: SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataWidget(datas: datas),
              )),
        ),
      ),
    ]);
  }
}
