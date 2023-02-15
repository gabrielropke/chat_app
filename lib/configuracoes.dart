import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
class Configuracoes extends StatefulWidget {
  const Configuracoes({Key? key}) : super(key: key);
 
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}
 
class _ConfiguracoesState extends State<Configuracoes> {
  TextEditingController _controllerNOME = TextEditingController(text: "");
  FirebaseStorage storage = FirebaseStorage.instance;
  XFile? _imagem;
  String? _idUsuarioLogado;
  bool _subindoImagem = false;
  String _urlImagemRecuperada = "";
 
  Future _recuperarImagem(String origemImagem) async {
    final ImagePicker _picker = ImagePicker();
    XFile? imagemSelecionada;
    FirebaseStorage storage = FirebaseStorage.instance;
    if (origemImagem == "camera") {
      imagemSelecionada = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _imagem = imagemSelecionada;
        if (_imagem != null) {
          _uploadImagem();
          _subindoImagem = true;
        }
      });
    } else if (origemImagem == "galeria") {
      imagemSelecionada = await _picker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imagem = imagemSelecionada;
      if (_imagem != null) {
        _uploadImagem();
        _subindoImagem = true;
      }
    });
  }
 
  Future _uploadImagem() async {
    File file = File(_imagem!.path);
    Reference pastaRaiz = await storage.ref();
    Reference arquivo =
        await pastaRaiz.child("perfil").child(_idUsuarioLogado! + ".jpg");
 
    UploadTask task = arquivo.putFile(file);
 
    task.snapshotEvents.listen((TaskSnapshot storageEvent) {
      if (storageEvent.state == TaskState.running) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageEvent.state == TaskState.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });
 
    task.then((TaskSnapshot taskSnapshot) => _recuperarURLimagem(taskSnapshot));
  }
 
  Future _recuperarURLimagem(TaskSnapshot taskSnapshot) async {

    String url = await taskSnapshot.ref.getDownloadURL();

    _atualizarURLimagemFirestore( url );

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _atualizarURLimagemFirestore( String url ){

    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "urlImagem" : url
    };

    db.collection("usuarios")
    .doc(_idUsuarioLogado)
    .update( dadosAtualizar );
  }

  
  _atualizarNomeFirestore(){

    String nome = _controllerNOME.text;

    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "nome" : nome
    };

    db.collection("usuarios")
    .doc(_idUsuarioLogado)
    .update( dadosAtualizar );
  }
 
 
  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = auth.currentUser!;
    _idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = 
    await db.collection("usuarios")
    .doc( _idUsuarioLogado )
    .get();

    Map<String, dynamic> dados = snapshot.data() as Map<String, dynamic>;
    _controllerNOME.text = dados["nome"];

    if( dados["urlImagem"] != null ){
    setState(() {
      _urlImagemRecuperada = dados["urlImagem"];
    });
  }

  }
 
  @override
  void initState() {
    _recuperarDadosUsuario();
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 22, 22, 22),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 60),
            child: const Text("Editar perfil"),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey,
                        backgroundImage: _urlImagemRecuperada != null
                            ? NetworkImage(_urlImagemRecuperada)
                            : null
                            ),
                    _subindoImagem ? CircularProgressIndicator() : Container()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => _recuperarImagem("camera"),
                      child: Text("Câmera",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16
                      ),),
                    ),
                    TextButton(
                      onPressed: () => _recuperarImagem("galeria"),
                      child: Text("Galeria",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16
                      ),),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                  child: TextField(
                    controller: _controllerNOME,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    onChanged: (texto){
                      _atualizarNomeFirestore();
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Color.fromARGB(255, 24, 24, 24),
                      hintText: "Defina o seu nome",
                      hintStyle: TextStyle(color: Color.fromARGB(255, 100, 100, 100)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 148, 48, 168),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    onPressed: () {

                      _atualizarNomeFirestore();

                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Salvar",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
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
 