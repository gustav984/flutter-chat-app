
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat/globals/enviroments.dart';
import 'package:flutter_chat/models/login_response.dart';
import 'package:flutter_chat/models/usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class AuthServices with ChangeNotifier{

  Usuario? usuario;
  bool _autenticando= false;
  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => _autenticando;

  set autenticando(bool valor){
    _autenticando=valor;
    notifyListeners();
  }

  //Getters del token de forma estática
  static Future<String?> getToken()async{
    final _storage = new FlutterSecureStorage();
    final token= await _storage.read(key: 'token');
    return token;

  }

  static Future<void> deleteToken()async{
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }


  //final usuario;???   
  Future<bool> login(String email,String password)async{

    autenticando=true;

    final data = {
      'email':email,
      'password':password
    };

    final resp=await http.post(Uri.parse(Enviroments.apiUrl+'/login'),
      body: jsonEncode(data),
      headers: {
        'Content-type':'application/json'
      }
    );
    print(resp);
    autenticando=false;

    if( resp.statusCode == 200){
      final loginResp = loginResponseFromJson(resp.body);
      usuario=loginResp.usuario;
      
      await _guardarToken(loginResp.token);
      return true;
    }else{
      return false;
    }

    

  }

  Future<String> register(String name,String email,String password)async{

      autenticando=true;

    final data = {
      'email':email,
      'password':password,
      'nombre':name,
    };

    final resp=await http.post(Uri.parse(Enviroments.apiUrl+'/login/new'),
      body: jsonEncode(data),
      headers: {
        'Content-type':'application/json'
      }
    );
    print(resp.body);
    autenticando=false;

    if( resp.statusCode == 200){
      final loginResp = loginResponseFromJson(resp.body);
      usuario=loginResp.usuario;
      await _guardarToken(loginResp.token);

      return 'true';
    }else{
      final respBody=jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn()async{
    print('isLoggedIn');
    final token = await _storage.read(key: 'token');

    final resp=await http.get(Uri.parse(Enviroments.apiUrl+'/login/renew'),
      headers: {
        'Content-type':'application/json',
        'x-token':token??'',
      }
    );
    


    if( resp.statusCode == 200){

      final loginResp = loginResponseFromJson(resp.body);
      usuario=loginResp.usuario;
      print(usuario);
      await _guardarToken(loginResp.token);

      return true;
    }else{
   
      logout();
      return false;
    }
  }


  Future _guardarToken(String token)async{//GUARDAR EN LUGAR SEGURO
    return await _storage.write(key: 'token', value: token);
  }

  Future logout()async{
    // Delete value
    await _storage.delete(key: 'token');
  }
}
