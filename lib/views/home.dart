import 'package:flutter/material.dart';
import 'package:jdsaa/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DataStructures And Algorithms")),
      body: ListView(children: [
        ListTile(
          title: const Text("Show Anims"),
          onTap: () => Navigator.pushNamed(context, Routes.animsIndex, arguments: List.generate(20, (index) => index + 10)),
        ),
        const Divider()
      ]),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.animation),
          onPressed: () {
            setState(() {});
          }),
    );
  }
}
