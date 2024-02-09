import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:utente/utils.dart';

class Prenota extends StatefulWidget {
  final String codiceFiscale;
  const Prenota({Key? key, required this.codiceFiscale}) : super(key: key);

  @override
  State<Prenota> createState() => _PrenotaState();
}

class _PrenotaState extends State<Prenota> with TickerProviderStateMixin {
  List<Widget> children1 = <Widget>[
    const Icon(
      Icons.error_outline,
      color: Colors.red,
      size: 60,
    ),
    const Padding(
      padding: EdgeInsets.only(top: 16),
      child: Text('Errore nel caricamento dei dati'),
    )
  ];
  late AnimationController controller;
  bool _fatto = false;
  bool _prenotato = false;
  int _key = 0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List<String>> _getUtente() async {
    List<String> _utente = [];
    var collection = FirebaseFirestore.instance
        .collection('Utenti')
        .doc(widget.codiceFiscale);
    var docSnapshot = await collection.get();
    if (docSnapshot.exists) {
      _utente.add(docSnapshot.get('nome'));
      _utente.add(docSnapshot.get('cognome'));
      _utente.add(docSnapshot.get('indirizzo'));

      return _utente;
    }
    return _utente;
  }

  Future<Color> _getColor(String id) async {
    var collection = FirebaseFirestore.instance
        .collection('ritiroIngombranti')
        .doc(id)
        .collection('tickets');
    var docSnapshot = await collection.get();
    if (docSnapshot.docs.isNotEmpty) {
      for (var i in docSnapshot.docs) {
        if (i.id == widget.codiceFiscale) return Colors.green;
      }
    }
    return Colors.orange;
  }

  Future<bool> aggiungi(String id) async {
    List<String> _utente = await _getUtente();

    FirebaseFirestore _firestoreUtente = FirebaseFirestore.instance;
    _firestoreUtente.collection('Utenti').doc(widget.codiceFiscale).snapshots();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.runTransaction((transaction) async {
      DocumentReference puntiRef = _firestore
          .collection('ritiroIngombranti')
          .doc(id)
          .collection('tickets')
          .doc(widget.codiceFiscale);

      DocumentSnapshot snap = await transaction.get(puntiRef);

      transaction.set(puntiRef, {
        'indirizzo': _utente[2],
        'nome': _utente[0],
        'cognome': _utente[1],
        'ritirato': false
      });
    });

    return _utente.isEmpty ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prenota ritiro'),
        backgroundColor: const Color(0xFF666666),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ritiroIngombranti')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.docs.isEmpty
                ? const Center(
                    child: Text(
                      "Non ci sono ritiri programmati",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Padding(
                          padding: EdgeInsets.all(18),
                          child: Divider(
                            thickness: 1.5,
                          ));
                    },
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      _prenotato = false;

                      DocumentSnapshot doc = snapshot.data!.docs[index];

                      return Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text('  ' + doc.id),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              key: ValueKey(_key),
                              stream: FirebaseFirestore.instance
                                  .collection('ritiroIngombranti')
                                  .doc(doc.id)
                                  .collection('tickets')
                                  .snapshots(),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    child: Column(children: [
                                      const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text('  Stato prenotazioni')),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: LinearPercentIndicator(
                                          lineHeight: 5,
                                          percent: snap.data!.docs.isNotEmpty
                                              ? (snap.data!.docs.length - 1) /
                                                  doc['numero']
                                              : (snap.data!.docs.length) /
                                                  doc['numero'],
                                          progressColor: (snap
                                                          .data!.docs.isNotEmpty
                                                      ? (snap.data!.docs
                                                                  .length -
                                                              1) /
                                                          doc['numero']
                                                      : (snap.data!.docs
                                                              .length) /
                                                          doc['numero']) >
                                                  0.75
                                              ? Colors.red
                                              : (snap.data!.docs.isNotEmpty
                                                          ? (snap.data!.docs
                                                                      .length -
                                                                  1) /
                                                              doc['numero']
                                                          : (snap.data!.docs
                                                                  .length) /
                                                              doc['numero']) >
                                                      0.55
                                                  ? Colors.yellow
                                                  : Colors.green,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            if (doc['numero'] >
                                                    (snap.data!.docs.length -
                                                        1) &&
                                                await _getColor(doc.id) !=
                                                    Colors.green) {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text(
                                                      'Prenotazione'),
                                                  content: Text(
                                                      'Sei sicuro di voler prenotare un ritiro per il giorno ' +
                                                          doc.id),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Cancel'),
                                                      child: const Text('No'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await aggiungi(doc.id)
                                                            .then((value) =>
                                                                _fatto = value);
                                                        Utils.showSnackBar(
                                                            _fatto
                                                                ? 'Prenotazione effettuata con successo'
                                                                : 'C\'è stato un problema nella prenotazione',
                                                            _fatto
                                                                ? Colors.green
                                                                : Colors.red);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Si'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          child: FutureBuilder<Color>(
                                            future: _getColor(doc
                                                .id), // a previously-obtained Future<String> or null
                                            builder: (BuildContext context,
                                                AsyncSnapshot<Color> color) {
                                              List<Widget> children;
                                              if (snapshot.hasData) {
                                                children = <Widget>[
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: doc['numero'] >
                                                                  (snap
                                                                          .data!
                                                                          .docs
                                                                          .length -
                                                                      1)
                                                              ? color.data
                                                              : Colors.grey),
                                                      child: Center(
                                                          child: Text(color
                                                                      .data ==
                                                                  Colors.green
                                                              ? 'Prenotato'
                                                              : 'Prenota')))
                                                ];
                                              } else if (snapshot.hasError) {
                                                children = <Widget>[
                                                  const Icon(
                                                    Icons.error_outline,
                                                    color: Colors.red,
                                                    size: 50,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 16),
                                                    child: Text(
                                                        'Error: ${snapshot.error}'),
                                                  )
                                                ];
                                              } else {
                                                children = <Widget>[
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 50,
                                                    child:
                                                        const CircularProgressIndicator(),
                                                  ),
                                                ];
                                              }
                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: children,
                                                ),
                                              );
                                            },
                                          ))
                                    ]),
                                  );
                                } else {
                                  return const Center(
                                    child: Text(
                                      "informazione momentaneaente non disponibile",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    });
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children1,
              ),
            );
          }
        },
      ),
    );
  }
}
