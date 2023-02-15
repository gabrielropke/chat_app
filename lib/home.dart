import 'package:chat_grv/configuracoes.dart';
import 'package:chat_grv/login.dart';
import 'package:chat_grv/telas/contatos.dart';
import 'package:chat_grv/telas/conversas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<home> with SingleTickerProviderStateMixin {

  TabController? _tabController;

  List<String> itensMenu = [
    "Perfil",
    "Deslogar"
  ];

  String _emailUsuario= "";

  Future _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;

    setState(() {
      _emailUsuario = usuarioLogado.email!;
    });
    
  }

  Future _verificaUsuarioLogado() async {
    
    FirebaseAuth auth = FirebaseAuth.instance;

    User usuarioLogado = await auth.currentUser!;
    if( usuarioLogado == null ){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => login())));
    }

  }

  @override
  void initState(){
    super.initState();

    _verificaUsuarioLogado();
    _recuperarDadosUsuario();
    _tabController = TabController(
      length: 2, 
      vsync: this
      );

  }

  _escolhaMenuItem(String itemEscolhido){

    switch( itemEscolhido ){
      case "Perfil":
        Navigator.push(context, MaterialPageRoute(builder: ((context) => Configuracoes())));
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;  
    }
    //print("Item escolhido" + itemEscolhido );

  }

  _deslogarUsuario(){

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => login())));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Text("Chat"),
          )),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          controller: _tabController,
          indicatorColor: Color.fromARGB(255, 192, 45, 206),
          tabs: [
            Tab(text: "Conversas",),
            Tab(text: "Contatos",)
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },  
          )
        ],
        backgroundColor: Color.fromARGB(255, 22, 22, 22),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          conversas(),
          contatos(),
        ],
      )
    );
  }
}