import 'package:flutter/material.dart';

class teladois extends StatefulWidget {
  const teladois({super.key});

  @override
  State<teladois> createState() => _teladoisState();
}

class _teladoisState extends State<teladois> {
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
              padding: const EdgeInsets.only(top: 50),
              child: Text("INSTRUÇÕES:",
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
              child: Text(" Você pode alterar a sua foto\n clicando nos 3 pontinhos no\n canto superior direito > perfil.",
                style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontSize: 20
                  )),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text("           Você também pode alterar\no seu nome que será visto pelos outros\nusuários na mesma aba onde definirá\n                 a sua foto de perfil.",
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