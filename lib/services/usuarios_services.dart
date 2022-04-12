
import 'package:flutter_chat/globals/enviroments.dart';
import 'package:flutter_chat/models/usuarios_response.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat/models/usuario.dart';

class UsuariosServices{

  Future<List<Usuario>> getUsuarios()async{

    try{
      
      final resp = await http.get(Uri.parse(Enviroments.apiUrl+'/usuarios'),
        headers: {
          'Content-Type' : 'application/json',
          'x-token':await AuthServices.getToken()??''
        }
      );     

      final usuariosRensponse = usuariosRensponseFromJson( resp.body );

      return usuariosRensponse.usuarios;

    }catch(error){
      return [];
    }

  }
}