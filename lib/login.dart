import 'package:chat_grv/cadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_grv/model/usuario.dart';

import 'home.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos(){

    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if( email.isNotEmpty && email.contains("@")){

        if( senha.isNotEmpty ){

          setState(() {
            _mensagemErro = "";
          });

          Usuario usuario = Usuario();
          usuario.email = email;
          usuario.senha = senha;

          _logarUsuario( usuario );

    }else{
      setState(() {
        _mensagemErro = "Preencha a senha!";
      });
    }

    }else{
      setState(() {
        _mensagemErro = "E-mail inválido";
      });
    }
  }

  _logarUsuario( Usuario usuario ){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
      email: usuario.email, 
      password: usuario.senha
      ).then((FirebaseUser){

        Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => home())));

      }).catchError((error){

        setState(() {
          _mensagemErro = "Verifique o login e senha e tente novamente!";
        });

      });

  }

  Future _verificaUsuarioLogado() async {
    
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();

    User usuarioLogado = await auth.currentUser!;
    if( usuarioLogado != null ){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => home())));
    }

  }

  @override
  void initState(){
    _verificaUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 22, 22, 22)
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 82),
                  child: SizedBox(
                    width: 10,
                    height: 180,
                    child: Image.asset("assets/logoapp.png"),
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8, right: 20, left: 20),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: new Icon(Icons.email, 
                      color: Color.fromARGB(255, 94, 94, 94),),
                      contentPadding: EdgeInsets.fromLTRB(32, 15, 32, 16),
                      hintText: "E-mail",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 94, 94, 94),
                        fontWeight: FontWeight.bold
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 39, 39, 39),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 17, right: 20, left: 20),
                  child: TextField(
                    controller: _controllerSenha,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key,
                        color: Color.fromARGB(255, 94, 94, 94),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(32, 15, 32, 16),
                        hintText: "Senha",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 94, 94, 94),
                          fontWeight: FontWeight.bold
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 39, 39, 39),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14)
                        )
                      ),
                    ),
                ),
                  Padding(
                    padding: EdgeInsets.only(top: 46, bottom: 10, right: 20, left: 20),
                    child: ElevatedButton(
                      onPressed: (){
                        _validarCampos();
                      }, 
                      child: Text('Entrar',
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
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? cadastre-se.",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => cadastro()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16)),
                  Center(
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}