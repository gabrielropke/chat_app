import 'package:chat_grv/mensagens.dart';
import 'package:chat_grv/telas/conversas.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
class contatos extends StatefulWidget {
  const contatos({Key? key}) : super(key: key);
  @override
  _AbaContatosState createState() => _AbaContatosState();
}


 
class _AbaContatosState extends State<contatos> {
  String? _emailUsuarioLogado;
  Future<List<Usuario>> _recuperarContatos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection("usuarios").get();
    List<Usuario> listaUsuarios = [];
    for (DocumentSnapshot item in querySnapshot.docs) {
      Map dadosmap = {};
      var dados = item.data();
      dadosmap = dados as Map;
      print(_emailUsuarioLogado);
      if (dadosmap["email"] == _emailUsuarioLogado) continue;
      
      Usuario usuario = Usuario();
      usuario.idUsuario = item.id;
      usuario.email = dados["email"];
      usuario.nome = dados["nome"];
      usuario.urlImagem = dados["urlImagem"];
      listaUsuarios.add(usuario);
      listaUsuarios.sort((a,b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
    }
    return listaUsuarios;
  }

 
  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var usuariologado = auth.currentUser;
    _emailUsuarioLogado = usuariologado?.email;
  }
  
  @override
  void initState() {
    _recuperarDadosUsuario();
    _recuperarContatos();
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
        future: _recuperarContatos(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 250),
                      child: Text(""),
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (_, indice) {
                      List<Usuario>? listaItens = snapshot.data;
                      Usuario usuario = listaItens![indice];
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context,
                          "/mensagens",
                          arguments: usuario
                          );
                        },
                        contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        leading: CircleAvatar(
                            maxRadius: 30,
                            backgroundColor: Colors.grey,
                            backgroundImage: usuario.urlImagem != null
                                ? NetworkImage(usuario.urlImagem)
                                : null),
                        title: Text(
                          usuario.nome,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16,
                              color: Color.fromARGB(255, 180, 180, 180)),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: Text("Não há contatos"),
                );
              }
          }
        });
  }
}