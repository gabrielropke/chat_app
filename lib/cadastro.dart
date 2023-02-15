import 'dart:math';
import 'package:chat_grv/home.dart';
import 'package:chat_grv/login.dart';
import 'package:chat_grv/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class cadastro extends StatefulWidget {
  const cadastro({super.key});

  @override
  State<cadastro> createState() => _cadastroState();
}

class _cadastroState extends State<cadastro> {

  //Controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos(){

    //Recupera dados dos campos
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if( nome.isNotEmpty ){

      if( email.isNotEmpty && email.contains("@")){

        if( senha.isNotEmpty && senha.length >= 6){

          setState(() {
            _mensagemErro = "";
          });

          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;

          _cadastrarUsuario( usuario );

    }else{
      setState(() {
        _mensagemErro = "A senha precisa conter 6 caracteres";
      });
    }

    }else{
      setState(() {
        _mensagemErro = "E-mail inválido";
      });
    }
    }else{
      setState(() {
        _mensagemErro = "Preencha o Nome";
      });
    }

  }

  _cadastrarUsuario( Usuario usuario ){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
      email: usuario.email, 
      password: usuario.senha
    ).then((FirebaseUser){

      //Salvar dados do usuário
      FirebaseFirestore db = FirebaseFirestore.instance;

      db.collection("usuarios")
      .doc( FirebaseUser.user!.uid)
      .set( usuario.toMap() );
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => home())));

    }).catchError((error){
      print("erro app: " + error .toString());
      setState(() {
        _mensagemErro = "E-mail já cadastrado!";
      });

    });
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
                  padding: EdgeInsets.only(bottom: 70),
                  child: SizedBox(
                    width: 10,
                    height: 180,
                    child: Image.asset("assets/logoapp.png"),
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle,
                        color: Color.fromARGB(255, 94, 94, 94),
                        ),
                      contentPadding: EdgeInsets.fromLTRB(32, 15, 32, 16),
                      hintText: "Nome",
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
                  padding: EdgeInsets.only(bottom: 8, top: 15),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email,
                        color: Color.fromARGB(255, 94, 94, 94),
                        ),
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
                  padding: const EdgeInsets.only(top: 15),
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
                    padding: EdgeInsets.only(top: 46, bottom: 10),
                    child: ElevatedButton(
                      onPressed: (){
                        _validarCampos();
                      }, 
                      child: Text('Cadastrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
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
                      "Já tem uma conta? Clique aqui.",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login()));
                    },
                  ),
                ),
                Center(
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}