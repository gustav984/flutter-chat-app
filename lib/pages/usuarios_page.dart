
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/usuario.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/chat_service.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:flutter_chat/services/usuarios_services.dart';
import 'package:flutter_chat/widgets/chat_message.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {



  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  final usuarioService = new UsuariosServices();

  List<Usuario> usuarios=[];


  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final authServices= Provider.of<AuthServices>(context);
    final socketService= Provider.of<SocketService>(context);
    final usuario= authServices.usuario;
    String nombre=usuario!.nombre;
    print('ESTADOOO');
    print(socketService.serverStatus);

    return Scaffold(
      appBar: AppBar(
        title: Text(nombre,style: TextStyle(color: Colors.black54),),
        centerTitle: true,
        elevation: 1,
        backgroundColor:Colors.white ,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app_outlined,color: Colors.black,),
          onPressed: (){ 
            //TODO Desconectar del socket server
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthServices.deleteToken();
          }, 
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child:(socketService.serverStatus==ServerStatus.Online)? Icon(Icons.check_circle,color: Colors.blue[400],):Icon(Icons.offline_bolt,color: Colors.red,),
            //child: Icon(Icons.offline_bolt,color: Colors.red,),
          )
        ],
      ),
      body: SmartRefresher( 
        controller: _refreshController,
        onRefresh: _cargarUsuarios,
        child: _listViewUsuarios(),
      )
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (_,index)=>Divider(), 
      itemBuilder: (_,index)=>_usuarioListTile(usuarios[index]), 
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title:Text(usuario.nombre) ,
      subtitle: Text(usuario.email),
      leading:CircleAvatar(
        backgroundColor: Colors.blue[100 ],
        child:Text(usuario.nombre.substring(0,2)) ,
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: (usuario.online)?Colors.green[300]:Colors.red,
          borderRadius: BorderRadius.circular(100)
        ),
      ),
      onTap: (){
        final chatService= Provider.of<ChatService>(context,listen: false);
        chatService.usuarioPara= usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios()async{
    //await Future.delayed(Duration(milliseconds: 1000));
    
    this.usuarios = await usuarioService.getUsuarios();
    setState(() {});

    _refreshController.refreshCompleted();
  }

}