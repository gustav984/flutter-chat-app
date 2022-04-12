import 'package:flutter/material.dart';
import 'package:flutter_chat/globals/enviroments.dart';
import 'package:flutter_chat/models/mensajes_response.dart';
import 'package:flutter_chat/models/usuario.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier{

  Usuario? usuarioPara;

  Future<List<Mensaje>> getChat( String usuarioID)async{

    final resp = await http.get(Uri.parse(Enviroments.apiUrl+'/mensajes/$usuarioID'),
      headers: {
        'Content-Type' : 'application/json',
        'x-token':await AuthServices.getToken()??''
      }
    
    );

    final mensajesResponse = mensajesRensponseFromJson(resp.body);

    return mensajesResponse.mensajes;

  }

}