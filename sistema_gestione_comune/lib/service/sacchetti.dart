import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> getNumeroSacchetti() async {
  var collection = FirebaseFirestore.instance.collection('sacchetti');
  var docSnapshot = await collection.doc('sacchetti').get();

  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();

    // You can then retrieve the value from the Map like this:
    return data?['numero'];
  } else {
    return 0;
  }
}

Future<bool> getConferma() async {
  var collection = FirebaseFirestore.instance.collection('sacchetti');
  var docSnapshot = await collection.doc('sacchetti').get();

  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();

    // You can then retrieve the value from the Map like this:
    return data?['conferma'];
  } else {
    return false;
  }
}

Future<DateTime> getOrdine() async {
  var collection = FirebaseFirestore.instance.collection('sacchetti');
  var docSnapshot = await collection.doc('sacchetti').get();

  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();

    // You can then retrieve the value from the Map like this:
    var x = data?['arrivo'] as Timestamp;
    return x.toDate();
  } else {
    return DateTime.now();
  }
}

decrementSacchetti() async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.runTransaction((transaction) async {
    DocumentReference puntiRef =
        _firestore.collection('sacchetti').doc('sacchetti');
    DocumentSnapshot snap = await transaction.get(puntiRef);
    Map<String, dynamic>? data = snap.data() as Map<String, dynamic>?;
    int numero = data?['numero'];
    transaction.update(puntiRef, {'numero': numero - 1});
  });
}

aggiungiSacchetti(int i) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.runTransaction((transaction) async {
    DocumentReference puntiRef =
        _firestore.collection('sacchetti').doc('sacchetti');
    DocumentSnapshot snap = await transaction.get(puntiRef);
    Map<String, dynamic>? data = snap.data() as Map<String, dynamic>?;
    int numero = data?['numero'];
    transaction.update(puntiRef, {'numero': numero + i});
  });
}

aggiungiOrdine(int i) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.runTransaction((transaction) async {
    DocumentReference puntiRef =
        _firestore.collection('sacchetti').doc('sacchetti');
    DocumentSnapshot snap = await transaction.get(puntiRef);
    Map<String, dynamic>? data = snap.data() as Map<String, dynamic>?;
    int numero = data?['numero'];
    transaction.update(puntiRef, {'numero': numero + i});
  });
}

Future<bool> cambiaStatoConferma(bool i) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentReference docRef =
      _firestore.collection('sacchetti').doc('sacchetti');

  WriteBatch write = _firestore.batch();

  write.update(docRef, {'conferma': i});
  write.commit();
  return true;
}

Future<bool> cambiaArrivo() async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentReference docRef =
      _firestore.collection('sacchetti').doc('sacchetti');

  WriteBatch write = _firestore.batch();

  write.update(
      docRef, {'arrivo': DateTime.now().add(const Duration(minutes: 3))});
  write.commit();
  return true;
}
