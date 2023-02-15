import 'package:chat_grv/login.dart';
import 'package:flutter/material.dart';

class telatres extends StatefulWidget {
  const telatres({super.key});

  @override
  State<telatres> createState() => _telatresState();
}

class _telatresState extends State<telatres> {
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
              padding: const EdgeInsets.only(top: 30),
              child: Text("LEMBRE-SE!",
              style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 42
                )),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(" Este app foi desenvolvido a fins\nde estudos, sendo como projeto\n     para o portfólio do criador.",
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
              child: Text("        Todos os usuários cadastrados\npodem ser encontrados na aba contatos.",
                style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontSize: 20
                  )),
            ),
          ),
          Padding(
                    padding: EdgeInsets.only(top: 46),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login()));
                      }, 
                      child: Text('VAMOS LÁ!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 121, 38, 124),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)
                      )
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}