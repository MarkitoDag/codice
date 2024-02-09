import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> transazioneSacchetti(
    String richiedente, String addetto, String codice) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentReference docRef = _firestore.collection('consegna_sacchetti').doc();

  WriteBatch write = _firestore.batch();

  write.set(docRef, {
    'addetto': addetto.toUpperCase(),
    'richiedente': richiedente.toUpperCase(),
    'codice': codice,
    'data': DateTime.now()
  });
  write.commit();
  FirebaseFirestore _firestore1 = FirebaseFirestore.instance;
  DocumentReference docRef1 = _firestore1
      .collection('Utenti')
      .doc(richiedente.toUpperCase())
      .collection('messaggi')
      .doc();
  WriteBatch write1 = _firestore.batch();
  write1.set(docRef1, {
    'data': DateTime.now(),
    'body':
        'Ti sono stati consegnati i sacchetti con codice: $codice, dall\'addetto: $addetto'
  });
  write1.commit();
  FirebaseFirestore _firestore12 = FirebaseFirestore.instance;
  await _firestore12.runTransaction((transaction) async {
    DocumentReference puntiRef =
        _firestore.collection('Utenti').doc(richiedente.toUpperCase());
    DocumentSnapshot snap = await transaction.get(puntiRef);
    Map<String, dynamic>? data = snap.data() as Map<String, dynamic>?;
    List codici = data?['sacchetti'] as List;
    codici.add(codice);
    transaction.update(puntiRef, {'sacchetti': codici});
  });

  return true;
}

Future<bool> assegnaSacchetti(String richiedente, String codice) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.runTransaction((transaction) async {
    DocumentReference puntiRef =
        _firestore.collection('Utenti').doc(richiedente);
    DocumentSnapshot snap = await transaction.get(puntiRef);
    Map<String, dynamic>? data = snap.data() as Map<String, dynamic>?;
    List sacchetti = data?['sacchetti'] as List;
    if (sacchetti.contains(codice)) return false;
    sacchetti.add(codice);
    transaction.update(puntiRef, {'sacchetti': sacchetti});
    DocumentReference docRef = _firestore.collection('Utenti').doc(richiedente);
    WriteBatch write = _firestore.batch();
    write.update(docRef, {'ultimoRitiro': DateTime.now()});
    write.commit();
  });

  return true;
}
