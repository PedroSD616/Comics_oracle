import 'package:comics_oracle_app/usuario.dart';

class Autenticador {
  static Future<Usuario?> login() async {
    return Usuario("Comics_Fan_nº1", "comicFan@gmail.com");
  }

  static Future<Usuario?> recuperarUsuario() async {
    return Usuario("Comics_Fan_nº1", "comicFan@gmail.com");
  }

  static Future<void> logout() async {
    //
  }
}
