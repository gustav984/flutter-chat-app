
import 'package:flutter/material.dart';
import 'package:flutter_chat/helpers/mostrar_alerta.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:flutter_chat/widgets/boton_azul.dart';
import 'package:flutter_chat/widgets/custom_input.dart';
import 'package:flutter_chat/widgets/labels.dart';
import 'package:flutter_chat/widgets/logo.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {

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
                 Logo(titulo: 'Mensseger',),
                 _Form(),
                 Labels(ruta: 'register',titulo: 'No tienes cuenta?',subTitulo: 'Crea una ahora!',),
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
 


  @override
  Widget build(BuildContext context) {
    final authServices=Provider.of<AuthServices>(context) ;
    final socketService=Provider.of<SocketService>(context) ;

    return Container(
      margin:const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
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
            text: 'Ingresar',
            onpress:(authServices.autenticando==true)
            ?null
            :()async{
              FocusScope.of(context).unfocus();
              final loginOk= await authServices.login(emailCtrl.text.trim(), passCtrl.text.trim()); 

              if(loginOk){
                //Vavegar a otra pantalla
                print('Correctooo');
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              }else{
                //Mostrar alerta
                mostrarAlerta(context,'Login incorrecto','Revise sus credenciales');
              }
            }
          )
        ],
      ),
    );
  }

}








