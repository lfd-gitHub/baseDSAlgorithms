import 'package:flutter/material.dart';

class DataWidget extends StatelessWidget {
  final List datas;

  const DataWidget({
    Key? key,
    required this.datas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: datas.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 8.0, crossAxisSpacing: 8.0, childAspectRatio: 1.0),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blue,
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "[$index]",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    )),
                Center(
                  child: Text(
                    "${datas[index]}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              ],
            ),
          );
        });
  }
}
