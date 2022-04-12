

import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/login_page.dart';
import 'package:flutter_chat/pages/usuarios_page.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    


    return Scaffold(
      body: FutureBuilder(
        future:checkLoginState(context) ,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 

           return Center(
             child:const  Text('Espere...'),
           );
        },
        
      ),
   );
  }

  Future checkLoginState(BuildContext context)async{
     print('FUTUREEE');
     final authService = Provider.of<AuthServices>(context,listen: false);
     final socketService=Provider.of<SocketService>(context,listen: false) ;

     final autenticado = await authService.isLoggedIn();

     if(autenticado){
       
       socketService.connect();
       Navigator.pushReplacement(
         context, 
         PageRouteBuilder(
           pageBuilder: (_,___,____) => UsuariosPage(),
           
         )
       );

     }else{
       Navigator.pushReplacement(
         context, 
         PageRouteBuilder(
           pageBuilder: (_,___,____) => LoginPage(),
         )
       );
     }

  }
}  