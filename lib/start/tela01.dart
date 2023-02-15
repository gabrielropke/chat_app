import 'package:chat_grv/start/tela00.dart';
import 'package:chat_grv/start/tela02.dart';
import 'package:chat_grv/start/tela03.dart';
import 'package:flutter/material.dart';

class telaum extends StatefulWidget {
  const telaum({super.key});

  @override
  State<telaum> createState() => _telaumState();
}

class _telaumState extends State<telaum> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(title: Text(""),
      backgroundColor: Color.fromARGB(255, 22, 22, 22),
      bottom: PreferredSize(
        preferredSize: Size(0, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: TabBar(
                    indicatorWeight: 0,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color.fromARGB(255, 22, 22, 22)
                    ),
                    tabs: [
                      Tab(text: ""),
                      Tab(text: ""),
                      Tab(text: ""),
              ],
                      ),
            ),
          ],
        ),
        )
        ),
        body: TabBarView(
          children: [
            Center(child: telazero()),
            Center(child: teladois()),
            Center(child: telatres()),
          ],
        ),
      ),
    );
  }
}