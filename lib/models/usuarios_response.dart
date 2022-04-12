// To parse this JSON data, do
//
//     final usuariosRensponse = usuariosRensponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_chat/models/usuario.dart';

UsuariosRensponse usuariosRensponseFromJson(String str) => UsuariosRensponse.fromJson(json.decode(str));

String usuariosRensponseToJson(UsuariosRensponse data) => json.encode(data.toJson());

class UsuariosRensponse {

    UsuariosRensponse({
        required this.ok,
        required this.usuarios,
    });

    bool ok;
    List<Usuario> usuarios;

    factory UsuariosRensponse.fromJson(Map<String, dynamic> json) => UsuariosRensponse(
        ok: json["ok"],
        usuarios: List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}

 