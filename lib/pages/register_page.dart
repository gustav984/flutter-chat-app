
import 'package:flutter/material.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:flutter_chat/widgets/boton_azul.dart';
import 'package:flutter_chat/widgets/custom_input.dart';
import 'package:flutter_chat/widgets/labels.dart';
import 'package:flutter_chat/widgets/logo.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat/helpers/mostrar_alerta.dart';


class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height*0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Logo(titulo: 'Registro',),
                 _Form(),
                 Labels(ruta: 'login',titulo: '¿Ya tienes cuenta?',subTitulo: 'Ingresa con tu cuenta',),
                 Text('Terminos y condiciones de uso',style:TextStyle(fontWeight: FontWeight.w200))
              ],
            ),
          ),
        ),
      )
   );
  }
}



class _Form extends StatefulWidget {
  const _Form({ Key? key }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl=TextEditingController();
  final passCtrl=TextEditingController();
  final nombreCtrl=TextEditingController();



  @override
  Widget build(BuildContext context) {
    final authServices=Provider.of<AuthServices>(context) ;
    final socketService=Provider.of<SocketService>(context) ;

    return Container(
      margin:EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nombreCtrl,
          ),

          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),

          CustomInput(
            icon: Icons.lock,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),

          BotonAzul(
            text: 'Crear cuenta',
            onpress:(authServices.autenticando==true)
            ?null
            :()async{
              FocusScope.of(context).unfocus();
              final registerOk= await authServices.register(nombreCtrl.text.trim(),emailCtrl.text.trim(), passCtrl.text.trim()); 

              if(registerOk=='true'){
                //TODO CONECTAR AL SOCKET SERVER
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              }else{
                //Mostrar alerta
                mostrarAlerta(context,'Registro incorrecto',registerOk);
              }
            }
          )
        ],
      ),
    );
  }

}








