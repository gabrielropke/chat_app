import 'dart:async';

import 'package:chat_grv/model/conversa.dart';
import 'package:chat_grv/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_grv/model/mensagem.dart';
import 'package:firebase_storage/firebase_storage.dart';
 
class Mensagens extends StatefulWidget {
  // para receber os dados
  Usuario contato;

  Mensagens(this.contato);
 
  @override
  _MensagensState createState() => _MensagensState();
}
 
class _MensagensState extends State<Mensagens> {
  String? _idUsuarioLogado;
  String? _idUsuarioDestinatario;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
 
  TextEditingController _controllerMensagem = TextEditingController();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  ScrollController _scrollController = ScrollController();
 
  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;
    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado!;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.data = Timestamp.now().toString();
      mensagem.tipo = "texto";
 
      //sala mensagem duas vezes ... uma para quem envia e outra para quem recebeu
      _salvarMensagem(_idUsuarioLogado!, _idUsuarioDestinatario!, mensagem);
      _salvarMensagem(_idUsuarioDestinatario!, _idUsuarioLogado!, mensagem);
      //Salvar conversa
      _salvarConversa( mensagem );
    }
  }

  _salvarConversa(Mensagem msg){

    //remetente

    Conversa cRemente = Conversa();
    cRemente.idRemetente = _idUsuarioLogado!;
    cRemente.idDestinatario = _idUsuarioDestinatario!;
    cRemente.mensagem = msg.mensagem;
    cRemente.nome = widget.contato.nome;
    cRemente.caminhoFoto = widget.contato.urlImagem;
    cRemente.tipoMensagem = msg.tipo;
    cRemente.salvar();

    //destinatario
    
    Conversa cDestinatario = Conversa();
    cDestinatario.idRemetente = _idUsuarioDestinatario!;
    cDestinatario.idDestinatario = _idUsuarioLogado!;
    cDestinatario.mensagem = msg.mensagem;
    cDestinatario.nome = widget.contato.nome;
    cDestinatario.caminhoFoto = widget.contato.urlImagem;
    cDestinatario.tipoMensagem = msg.tipo;
    cDestinatario.salvar();

  }
 
  _recuperarDadosUsuario() {
    User usuarioLogado = auth.currentUser!;
    _idUsuarioLogado = usuarioLogado.uid;
    _idUsuarioDestinatario = widget.contato.idUsuario;

    _adicionarListenerConversa();

  }
 
  _salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem msg) async {
    await _firebaseFirestore
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());
 
    // limpa texto
    _controllerMensagem.clear();
  }
 
  List<String> listaMensagens = [
    "Oi, tudo bem?...",
    "Oi",
    "Você é demais :)",
    "Sei... e?",
    "tudo bem?",
    "sim",
    "Incrível",
    "deve",
    "blz"
  ];
 
  _enviarFoto() {}

  Stream<QuerySnapshot>? _adicionarListenerConversa() {
    final stream = _firebaseFirestore
        .collection("mensagens")
        .doc(_idUsuarioLogado)
        .collection(_idUsuarioDestinatario!)
        .orderBy("data", descending: false)
        .snapshots();
 
    stream.listen((dados) {
      _controller.add(dados);
      Timer(Duration(seconds: 1),(){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }
 
  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }
 
  @override
  Widget build(BuildContext context) {
    // criando a caixa de digitacao POR UM VAR
    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerMensagem,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20,
                color: Colors.white),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: "Digite uma mensagem...",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 124, 124, 124)
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 24, 24, 24),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                    prefixIcon: IconButton(
                        icon: Icon(Icons.camera_alt,
                        color: Color.fromARGB(255, 110, 110, 110),), onPressed: _enviarFoto)),
              ),
            ),
          ),
          FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 176, 177, 132),
              child: Icon(Icons.send, color: Color.fromARGB(255, 22, 22, 22)),
              mini: true,
              onPressed: _enviarMensagem)
        ],
      ),
    );
 
    var stream = StreamBuilder(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando mensagens"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
 
            QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot<Object?>;
 
            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar os dados!"),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context, indice) {
 
                      //recupera mensagem
                      List<DocumentSnapshot> mensagens = querySnapshot.docs.toList();
                      DocumentSnapshot item = mensagens[indice];
 
                      double larguraContainer =
                          MediaQuery.of(context).size.width * 0.8;
 
                      //Define cores e alinhamentos
                      Alignment alinhamento = Alignment.centerRight;
                      Color cor = Color.fromARGB(255, 182, 137, 207);
                      if ( _idUsuarioLogado != item["idUsuario"] ) {
                        alinhamento = Alignment.centerLeft;
                        cor = Color.fromARGB(255, 26, 26, 26);
                      }
 
                      return Align(
                        alignment: alinhamento,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Container(
                            width: larguraContainer,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: cor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(8))),
                            child: Text(
                              item["mensagem"],
                              style: TextStyle(fontSize: 18,
                              color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
 
            break;
        }
      },
    );
 
    var listView = Expanded(
        child: ListView.builder(
            itemCount: listaMensagens.length,
            itemBuilder: (context, indice) {
              // largura do container em 80%
              double larguraContainer = MediaQuery.of(context).size.width * 0.8;
 
              // definir cor e alinhamento
              Alignment alinhamento = Alignment.centerRight;
              Color cor = Color(0xffd2ffa5);
 
              // o simbolo % é resto 2 dividido por 2 nao sobra resto entao é para
              if (indice % 2 == 0) {
                alinhamento = Alignment.centerLeft;
                cor = Colors.white;
              }
 
              return Align(
                alignment: alinhamento,
                child: Padding(
                  padding: EdgeInsets.all(3),
                  child: Container(
                    width: larguraContainer,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: cor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text(
                      listaMensagens[indice],
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              );
            }));
 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 22, 22, 22),
          title: Row(
        children: <Widget>[
          CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(widget.contato.urlImagem)),
          Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              widget.contato.nome,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      )),
      body: Container(
        width: MediaQuery.of(context)
            .size
            .width, //para a imagem preencher tudo na tela
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 31, 31, 31)  
          ),
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              stream,
              caixaMensagem
              //CaixaMensagem()
            ],
          ),
        )),
      ),
    );
  }
}
