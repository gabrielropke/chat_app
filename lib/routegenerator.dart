import 'package:chat_grv/configuracoes.dart';
import 'package:flutter/material.dart';
import 'cadastro.dart';
import 'home.dart';
import 'login.dart';
import 'mensagens.dart';
 
class RouteGenerator {
  static var args;
 
  static Route<dynamic> generateRoute(RouteSettings settings) {
 
    args = settings.arguments;
 
    switch( settings.name ){
      case "/":
        return MaterialPageRoute(
            builder: (_) => login());
      case "/login":
        return MaterialPageRoute(
            builder: (_) => login());
      case "/cadastro":
        return MaterialPageRoute(
            builder: (_) => cadastro());
      case "/home":
        return MaterialPageRoute(
            builder: (_) => home());
      case "/configuracoes":
        return MaterialPageRoute(
            builder: (_) => Configuracoes());
      case "/mensagens":
        return MaterialPageRoute(
            builder: (_) => Mensagens(args!));
      default:
        _erroRota();
    }
    return generateRoute(settings);
  }
 
  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(title: Text("Ops!"),),
            body: Center(
              child: Text("Tela não encontrada!:( "),
            ),
          );
        }
    );
  }
}