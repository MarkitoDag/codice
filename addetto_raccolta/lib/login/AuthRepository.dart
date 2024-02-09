import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  Future<String> login(
      {required String codiceFiscale, required String password}) async {
    var collection = FirebaseFirestore.instance.collection('addetti_raccolta');
    var docSnapshot = await collection.doc(codiceFiscale.toUpperCase()).get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      Codec<String, String> stringToBase64 = utf8.fuse(base64);

      // You can then retrieve the value from the Map like this:
      var value = data?['password'];
      String _decoded = stringToBase64.decode(value);
      if (password == _decoded) {
        return 'abc';
      } else {
        throw Exception('Password errata.');
      }
    } else {
      throw Exception('Utente non autorizzato');
    }
  }

  Future<void> signout() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<String> attemptToLogIn() async {
    await Future.delayed(const Duration(seconds: 1));
    throw Exception('Accesso non effettuato');
  }
}
