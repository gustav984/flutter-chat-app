import 'package:flutter/material.dart';
import 'package:flutter_chat/globals/enviroments.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus =ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket  get socket => _socket;

  Function get emit => _socket.emit;




  void connect()async{

    final token =await AuthServices.getToken();
    
    String urlSocket = Enviroments.socketUrl;
  
    _socket = IO.io(
      urlSocket,
      IO.OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .enableAutoConnect()
        .enableForceNew()
        .setExtraHeaders({
          'x-token': token
        }) // optional
        .build()
    );
    
    //Estado conectado
    _socket.onConnect((_) {
      debugPrint('Conectado por Socket');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    // Estado Desconectado
    _socket.onDisconnect((_) {
      debugPrint('Desconectado del Socket Server');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    

  }

  void disconnect(){
    _socket.disconnect();
  }


}