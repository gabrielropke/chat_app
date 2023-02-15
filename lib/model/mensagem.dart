
import 'package:flutter/material.dart';

class Mensagem {

  String? _idUsuario;
  String? _mensagem;
  String? _urlImagem;
  String? _tipo;
  String? _data;
  
  Mensagem();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "idUsuario" : this.idUsuario,
      "mensagem" : this.mensagem,
      "urlImage" : this.urlImagem,
      "tipo" : this.tipo,
      "data" : this.data,
    };

    return map;

  }

  String get data => _data!;
 
  set data(String value) {
    _data = value;
  }
 
  String get idUsuario => _idUsuario!;
 
  set idUsuario(String value) {
    _idUsuario = value;
  }
 
  String get mensagem => _mensagem!;
 
  set mensagem(String value) {
    _mensagem = value;
  }
 
  String get urlImagem => _urlImagem!;
 
  set urlImagem(String value) {
    _urlImagem = value;
  }

  String get tipo => _tipo!;
 
  set tipo(String value) {
    _tipo = value;
  }

  

}