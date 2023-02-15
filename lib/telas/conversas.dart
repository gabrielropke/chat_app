import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
 
class conversas extends StatefulWidget {
  @override
  _conversasState createState() => _conversasState();
}
 
class _conversasState extends State<conversas> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
 
  String? _idUsuarioLogado;
 
  final _controller = StreamController<QuerySnapshot>.broadcast();
 
  // RECUPERAR DADOS UM USUARIO
  _carregaarDadosIniciais() async {
    var usuario = await _firebaseAuth.currentUser;
      _idUsuarioLogado = usuario!.uid;
      _adicionarListenerConversa();
  }
 
  @override
  void initState() {
    setState(() {
    _carregaarDadosIniciais();
    });
  }
 
  Stream<QuerySnapshot>? _adicionarListenerConversa() {
    final stream = _firebaseFirestore
        .collection("conversas")
        .doc(_idUsuarioLogado)
        .collection("ultima_conversa")
        .snapshots();
 
    stream.listen((dados) {
      _controller.add(dados);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        "carregando conversas....",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            //     QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
            //
            if (snapshot.hasError) {
              return const Text("Erro ao carregar dados");
            } else {
              QuerySnapshot querySnapshot = snapshot.data! as QuerySnapshot;
              if (querySnapshot.docs.length == 0) {
                // if (querySnapshot.docs.length == 0) {
                return const Center(
                  child: Text(
                    "Você não tem nenhuma mensagem ainda :(",
                    style: TextStyle(
                      color: Color.fromARGB(255, 180, 180, 180),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (context, indice) {
                    List<DocumentSnapshot> conversas =
                        querySnapshot.docs.toList();
                    DocumentSnapshot item = conversas[indice];
 
                    String urlImagem = item["caminhoFoto"];
                    String tipo = item["tipoMensagem"];
                    String mensagem = item["mensagem"];
                    String nome = item["nome"];
 
                    print("IMAGEM => " + urlImagem);
                    print("TIPO => " + tipo);
                    print("MENSAGEM => " + mensagem);
                    print("NOME => " + nome);
 
                    return ListTile(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            urlImagem != null ? NetworkImage(urlImagem) : null,
                      ),
                      title: Text(
                        nome,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(tipo == "texto" ? mensagem : "Imagem...",
                          style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                    );
                  });
            }
        }
      },
    );
  }
}