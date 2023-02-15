import 'package:flutter/material.dart';

class telazero extends StatefulWidget {
  const telazero({super.key});

  @override
  State<telazero> createState() => _telazeroState();
}

class _telazeroState extends State<telazero> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 22, 22, 22),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: SizedBox(
              width: 250,
              height: 220,
              child: Image.asset("assets/logoapp.png"),),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Text("BEM-VINDO!!",
              style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 42
                )),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text("      Para uma melhor experiência\npedimos que mantenham o respeito\n   com todos os nossos usuários!",
                style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontSize: 20
                  )),
            ),
          ),
        ],
      ),
    );
  }
}