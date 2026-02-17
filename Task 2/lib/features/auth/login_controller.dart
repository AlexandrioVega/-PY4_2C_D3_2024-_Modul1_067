import 'dart:convert';
import 'package:crypto/crypto.dart';

class LoginController {
  // Database sederhana (Hardcoded)
  bool isLocked = false;
  int _Attempts = 1;
  String logInformasi = "Login Gagal! Gunakan admin/123 atau alex/456";

  static String hashPassword(String password){
    return sha256.convert(utf8.encode(password)).toString();
  }

  final Map<String, String> _pengguna = {
    "admin" : hashPassword("123"),
    "alex" : hashPassword("456")
  };


  void _lockLogin() {
    print("LOCKED!");
    isLocked = true;

    Future.delayed(const Duration(seconds: 10), () {
      print("UNLOCKED!");
      _Attempts = 1;
      isLocked = false;
    });
  }

  bool validasiPengguna(String username, String password) {
    return _pengguna.containsKey(username) && _pengguna[username] == password;
  }



  bool login(String username, String password) {
    print("isLocked: $isLocked | percobaan: $_Attempts");

    String hassingPassword = hashPassword(password);
    if (isLocked) {
      return false;
    }

    if (validasiPengguna(username, hassingPassword)) {
      _Attempts =0; 
      return true;
    }

    _Attempts += 1;
    if (_Attempts > 3) {
      _lockLogin();
    }
    return false;
  }

}
