import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  final VoidCallback? onpress;

  const BotonAzul({ 
    Key? key ,
    required this.onpress,
    required this.text,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed:onpress, 
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.blue,
        shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),),
      ),
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(text,style: TextStyle(color: Colors.white,fontSize: 17),),
        )
      ),
    );
  }
}