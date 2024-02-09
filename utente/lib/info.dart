import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:utente/codice_view.dart';
import 'package:utente/detail_view.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  double _tot2 = 0.0;
  double _tot = 0.0;
  String _codiceFiscale = '';
  String _nome_cognome = '';
  bool _finito = false;
  bool _finito2 = false;
  double _pesoP = 0.0;
  double _pesoS = 0.0;
  double _pesoU = 0.0;
  double _pesoC = 0.0;
  double _pesoV = 0.0;

  double _molt = 0.0;

  double _mediaP = 0.0;
  double _mediaS = 0.0;
  double _mediaU = 0.0;
  double _mediaC = 0.0;
  double _mediaV = 0.0;
  int _multe = 0;

  double _costoCarta = 0.0;
  double _costoVetro = 0.0;
  double _costoPlastica = 0.0;
  double _costoUmido = 0.0;
  double _costoSecco = 0.0;
  int _costoMulte = 0;
  double _Quota_fissa = 0.0;

  Future<bool> _getPersistente() async {
    var collection = FirebaseFirestore.instance
        .collection('Utenti')
        .doc(_codiceFiscale)
        .collection('codice_ritiro')
        .doc('codice');
    var docSnapshot = await collection.get();
    if (docSnapshot.exists) {
      if (docSnapshot.get('persistente')) {
        return true;
      }
    }
    return false;
  }

  Future<DateTime> _getScadenza() async {
    var collection = FirebaseFirestore.instance
        .collection('Utenti')
        .doc(_codiceFiscale)
        .collection('codice_ritiro')
        .doc('codice');
    var docSnapshot = await collection.get();
    if (docSnapshot.exists) {
      return docSnapshot.get('data').toDate().add(const Duration(days: 1));
    }
    return docSnapshot.get('data').toDate().add(const Duration(days: 7));
  }

  Future getMedia(String _cod) async {
    _multe = 0;
    int _confPlastica = 0;
    int _confCarta = 0;
    int _confSecco = 0;
    int _confVetro = 0;
    int _confUmido = 0;
    var collection = FirebaseFirestore.instance
        .collection('Utenti')
        .doc(_cod)
        .collection('carta');
    var docSnapshot = await collection.get();
    if (docSnapshot.docs.isNotEmpty) {
      for (var i in docSnapshot.docs) {
        double? _x;
        _x = double.tryParse((i.get('peso')));
        if (_x != null) {
          _pesoC = (_pesoC + _x);
        }
        if (i.get('segnalata')) {
          _multe = _multe + 1;
        }
        _confCarta = _confCarta + 1;
      }
    }
    collection = FirebaseFirestore.instance
        .collection('Utenti')
        .doc(_codiceFiscale)
        .collection('plastica');
    docSnapshot = await collection.get();
    if (docSnapshot.docs.isNotEmpty) {
      for (var i in docSnapshot.docs) {
        double? _x;
        _x = double.tryParse((i.get('peso')));
        if (_x != null) {
          _pesoP = (_pesoP + _x);
        }
        if (i.get('segnalata')) {
          _multe = _multe + 1;
        }
        _confPlastica = _confPlastica + 1;
      }
    }

    collection = FirebaseFirestore.instance
        .collection('Utenti')
        .doc(_codiceFiscale)
        .collection('secco');
    docSnapshot = await collection.get();
    if (docSnapshot.docs.isNotEmpty) {
      for (var i in docSnapshot.docs) {
        double? _x;
        _x = double.tryParse((i.get('peso')));
        if (_x != null) {
          _pesoS = (_pesoS + _x);
        }
        if (i.get('segnalata')) {
          _multe = _multe + 1;
        }
        _confSecco = _confSecco + 1;
      }
    }

    collection = FirebaseFirestore.instance
        .collection('Utenti')
        .doc(_codiceFiscale)
        .collection('vetro');
    docSnapshot = await collection.get();
    if (docSnapshot.docs.isNotEmpty) {
      for (var i in docSnapshot.docs) {
        double? _x;
        _x = double.tryParse((i.get('peso')));
        if (_x != null) {
          _pesoV = (_pesoV + _x);
        }
        if (i.get('segnalata')) {
          _multe = _multe + 1;
        }
        _confVetro = _confVetro + 1;
      }
    }

    collection = FirebaseFirestore.instance
        .collection('Utenti')
        .doc(_codiceFiscale)
        .collection('umido');
    docSnapshot = await collection.get();
    if (docSnapshot.docs.isNotEmpty) {
      for (var i in docSnapshot.docs) {
        double? _x;
        _x = double.tryParse((i.get('peso')));
        if (_x != null) {
          _pesoU = (_pesoU + _x);
        }
        if (i.get('segnalata')) {
          _multe = _multe + 1;
        }
        _confUmido = _confUmido + 1;
      }
    }

    _mediaC = _pesoC / _confCarta;
    _mediaP = _pesoP / _confPlastica;
    _mediaU = _pesoU / _confUmido;
    _mediaV = _pesoV / _confVetro;
    _mediaS = _pesoS / _confSecco;
  }

  Future<String> getUtente() async {
    var collection = FirebaseFirestore.instance.collection('Utenti');
    var docSnapshot = await collection.get();
    if (docSnapshot.docs.isNotEmpty) {
      for (var i in docSnapshot.docs) {
        if (i['email'].toString().toLowerCase() ==
            FirebaseAuth.instance.currentUser!.email!.toLowerCase()) {
          return i.id;
        }
      }
    }
    return 'Error';
  }

  Future<String> getNome() async {
    var collection =
        FirebaseFirestore.instance.collection('Utenti').doc(await getUtente());
    var docSnapshot = await collection.get();
    if (docSnapshot.exists) {
      return docSnapshot['nome'] + ' ' + docSnapshot['cognome'];
    }
    return 'errore';
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    bool _bool = await _getPersistente();
    DateTime _date = await _getScadenza();
    if (!_bool || DateTime.now().isAfter(_date)) {
      if (state == AppLifecycleState.resumed) {
// online
        var rng = Random();
        var code = rng.nextInt(90000000) + 10000000;
        FirebaseFirestore _firestore7 = FirebaseFirestore.instance;
        var docRef7 = _firestore7
            .collection('Utenti')
            .doc(_codiceFiscale)
            .collection('codice_ritiro')
            .doc('codice');
        docRef7.update({
          'codice': code.toString(),
          'data': DateTime.now(),
          'persistente': false,
        });
      } else {
// offline
        FirebaseFirestore _firestore7 = FirebaseFirestore.instance;
        var docRef7 = _firestore7
            .collection('Utenti')
            .doc(_codiceFiscale)
            .collection('codice_ritiro')
            .doc('codice');
        docRef7.update({
          'codice': '',
          'data': DateTime.now().subtract(const Duration(days: 7)),
          'persistente': false,
        });
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getUtente().then((value) {
      setState(() {
        _codiceFiscale = value;
        _finito = true;
      });
      getMedia(value).then((value2) {
        setState(() => _finito2 = true);
      });
    });
    _molt = DateTime(2022, 12, 31).difference(DateTime.now()).inDays / 7;

    super.initState();
  }

  @override
  Widget build(BuildContext context) => !_finito
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : !_finito2
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 7, top: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const RadialGradient(
                              center: Alignment.topRight,
                              radius: 20,
                              colors: [
                                Color(0xFF666666),
                                Color(0xFF87b837),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 0.3),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xFF666666),
                                  spreadRadius: 0,
                                  blurRadius: 1),
                            ],
                          ),
                          child: InkWell(
                            onTap: (() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CodiceView(
                                            codiceFiscale: _codiceFiscale,
                                          )),
                                )),
                            child: Stack(children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Utenti')
                                            .doc(_codiceFiscale)
                                            .collection('codice_ritiro')
                                            .doc('codice')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData &&
                                              snapshot.data!.exists) {
                                            return SizedBox(
                                              height: 50,
                                              width: 100,
                                              child: SfBarcodeGenerator(
                                                barColor: Colors.white,
                                                value: snapshot.data!['codice'],
                                                symbology: Code128C(),
                                                showValue: false,
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        })),
                              ),
                              Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      child: Text(
                                        'Benvenuto,',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: FutureBuilder<String>(
                                        future: getNome(), // async work
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return const Text(
                                                'Loading....',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              );
                                            default:
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}',
                                                    style: const TextStyle(
                                                        color: Colors.white));
                                              } else {
                                                return Text(
                                                  '${snapshot.data}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                );
                                              }
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 0.3),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xFF666666),
                                  spreadRadius: 0,
                                  blurRadius: 1),
                            ],
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Utenti')
                                            .doc(_codiceFiscale)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData &&
                                              snapshot.data!.exists) {
                                            var value =
                                                snapshot.data?['ultimoRitiro']
                                                    as Timestamp;
                                            return !snapshot.data!.exists
                                                ? const Center(
                                                    child: Text(
                                                      "No data",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )
                                                : Column(children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Ultimo ritiro:'),
                                                          Text(snapshot.data!
                                                                  .get(
                                                                      'ultimoRitiro')
                                                                  .toDate()
                                                                  .day
                                                                  .toString() +
                                                              '/' +
                                                              snapshot.data!
                                                                  .get(
                                                                      'ultimoRitiro')
                                                                  .toDate()
                                                                  .month
                                                                  .toString() +
                                                              '/' +
                                                              snapshot.data!
                                                                  .get(
                                                                      'ultimoRitiro')
                                                                  .toDate()
                                                                  .year
                                                                  .toString())
                                                        ]),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 3),
                                                      child: Row(children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10),
                                                            child: Text(
                                                              value.toDate().isBefore((DateTime
                                                                          .now()
                                                                      .subtract(
                                                                          const Duration(
                                                                              days: 7))))
                                                                  ? 'Ritiro disponibile'
                                                                  : 'Ritiro non disponibile',
                                                              style: TextStyle(
                                                                color: value
                                                                        .toDate()
                                                                        .isBefore((DateTime.now().subtract(const Duration(
                                                                            days:
                                                                                7))))
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                              ),
                                                            )),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: value
                                                                    .toDate()
                                                                    .isBefore((DateTime
                                                                            .now()
                                                                        .subtract(const Duration(
                                                                            days:
                                                                                7))))
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                          height: 10,
                                                          width: 10,
                                                        ),
                                                      ]),
                                                    ),
                                                  ]);
                                          } else {
                                            return const Center(
                                                child: Text(
                                              "No data",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ));
                                          }
                                        })),
                              ),
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('sacchetti')
                                    .doc('sacchetti')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return !snapshot.data!.exists
                                        ? const Center(
                                            child: Text(
                                              "Informazione non disponibile",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )
                                        : Column(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                      'Sacchetti disponibili:'),
                                                  Text(snapshot.data!['numero']
                                                      .toString())
                                                ],
                                              ),
                                            ),
                                            snapshot.data!['conferma']
                                                ? Container()
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 18),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'In arrivo:',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .amber),
                                                          ),
                                                          Text(
                                                            snapshot.data![
                                                                        'arrivo']
                                                                    .toDate()
                                                                    .day
                                                                    .toString() +
                                                                '-' +
                                                                snapshot.data![
                                                                        'arrivo']
                                                                    .toDate()
                                                                    .month
                                                                    .toString() +
                                                                '-' +
                                                                snapshot.data![
                                                                        'arrivo']
                                                                    .toDate()
                                                                    .year
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .amber),
                                                          )
                                                        ]),
                                                  ),
                                          ]);
                                  } else {
                                    return const Center(child: Text("No data"));
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Conferimenti dal 01/01/2022 al 31/12/2022:',
                        style:
                            TextStyle(color: Color(0xFF666666), fontSize: 14),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 500,
                        child: Stack(children: [
                          Positioned(
                            left: MediaQuery.of(context).size.width - 360,
                            bottom: 25,
                            child: Image.asset(
                              'assets/trunk.png',
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.none,
                              scale: 1.5,
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 327,
                            bottom: 145,
                            child: Container(
                              width: 125,
                              height: 125,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                gradient: const RadialGradient(
                                  center: Alignment.topRight,
                                  radius: 1.5,
                                  colors: [Colors.white, Color(0xFF87b837)],
                                ),
                                borderRadius: BorderRadius.circular(125),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black38,
                                      spreadRadius: 0,
                                      blurRadius: 10),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 163,
                            bottom: 145,
                            child: Container(
                              width: 125,
                              height: 125,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                gradient: const RadialGradient(
                                  center: Alignment.topRight,
                                  radius: 1.5,
                                  colors: [Colors.white, Color(0xFF87b837)],
                                ),
                                borderRadius: BorderRadius.circular(125),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black38,
                                      spreadRadius: 0,
                                      blurRadius: 10),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 355,
                            bottom: 285,
                            child: Container(
                              width: 125,
                              height: 125,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                gradient: const RadialGradient(
                                  center: Alignment.topRight,
                                  radius: 1.5,
                                  colors: [Colors.white, Color(0xFF87b837)],
                                ),
                                borderRadius: BorderRadius.circular(125),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black38,
                                      spreadRadius: 0,
                                      blurRadius: 10),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 140,
                            bottom: 285,
                            child: Container(
                              width: 125,
                              height: 125,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                gradient: const RadialGradient(
                                  center: Alignment.topRight,
                                  radius: 1.5,
                                  colors: [Colors.white, Color(0xFF87b837)],
                                ),
                                borderRadius: BorderRadius.circular(125),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black38,
                                      spreadRadius: 0,
                                      blurRadius: 10),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 240,
                            bottom: 325,
                            child: Container(
                              width: 125,
                              height: 125,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                gradient: const RadialGradient(
                                  center: Alignment.topRight,
                                  radius: 1.5,
                                  colors: [Colors.white, Color(0xFF87b837)],
                                ),
                                borderRadius: BorderRadius.circular(125),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black38,
                                      spreadRadius: 0,
                                      blurRadius: 10),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 365,
                            bottom: 205,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailView(
                                          cartella: 'plastica',
                                          codiceFiscale: _codiceFiscale))),
                              child: Container(
                                width: 125,
                                height: 125,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  gradient: const RadialGradient(
                                    center: Alignment.topRight,
                                    radius: 1.5,
                                    colors: [Colors.white, Colors.yellow],
                                  ),
                                  borderRadius: BorderRadius.circular(125),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black38,
                                        spreadRadius: 0,
                                        blurRadius: 10),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Palastica'),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Container(
                                        height: 0.3,
                                        width: 80,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Utenti')
                                            .doc(_codiceFiscale)
                                            .collection('plastica')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            _pesoP = 0;
                                            for (var i in snapshot.data!.docs) {
                                              double? _x;
                                              _x = double.tryParse(
                                                  (i.get('peso')));
                                              if (_x != null) {
                                                _pesoP = (_pesoP + _x);
                                              }
                                            }
                                            ;
                                            return snapshot.data!.docs.isEmpty
                                                ? const Center(
                                                    child: Text(
                                                      "No data",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )
                                                : Text(
                                                    _pesoP.toStringAsFixed(2) +
                                                        ' kg');
                                          } else {
                                            return const Center(
                                                child: Text(
                                              "No data",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ));
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 135,
                            bottom: 205,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailView(
                                            cartella: 'umido',
                                            codiceFiscale: _codiceFiscale,
                                          ))),
                              child: Container(
                                width: 125,
                                height: 125,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  gradient: const RadialGradient(
                                    center: Alignment.topRight,
                                    radius: 1.5,
                                    colors: [Colors.white, Colors.brown],
                                  ),
                                  borderRadius: BorderRadius.circular(125),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black38,
                                        spreadRadius: 0,
                                        blurRadius: 10),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Rifiuti organici'),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Container(
                                        height: 0.3,
                                        width: 80,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Utenti')
                                            .doc(_codiceFiscale)
                                            .collection('umido')
                                            .orderBy('data', descending: true)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            _pesoU = 0;
                                            for (var i in snapshot.data!.docs) {
                                              double? _x;
                                              _x = double.tryParse(
                                                  (i.get('peso')));
                                              if (_x != null) {
                                                _pesoU = (_pesoU + _x);
                                              }
                                            }
                                            ;
                                            return snapshot.data!.docs.isEmpty
                                                ? const Center(
                                                    child: Text(
                                                      "No data",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )
                                                : Text(
                                                    _pesoU.toStringAsFixed(2) +
                                                        ' kg');
                                          } else {
                                            return const Center(
                                                child: Text(
                                              "No data",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ));
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 185,
                            bottom: 305,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailView(
                                          cartella: 'carta',
                                          codiceFiscale: _codiceFiscale))),
                              child: Container(
                                width: 125,
                                height: 125,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  gradient: const RadialGradient(
                                    center: Alignment.topRight,
                                    radius: 1.5,
                                    colors: [Colors.white, Colors.blue],
                                  ),
                                  borderRadius: BorderRadius.circular(125),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black38,
                                        spreadRadius: 0,
                                        blurRadius: 10),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Carta e cartone'),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Container(
                                        height: 0.3,
                                        width: 80,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Utenti')
                                            .doc(_codiceFiscale)
                                            .collection('carta')
                                            .orderBy('data', descending: true)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            _pesoC = 0;
                                            for (var i in snapshot.data!.docs) {
                                              double? _x;
                                              _x = double.tryParse(
                                                  (i.get('peso')));
                                              if (_x != null) {
                                                _pesoC = (_pesoC + _x);
                                              }
                                            }

                                            return snapshot.data!.docs.isEmpty
                                                ? const Center(
                                                    child: Text(
                                                      "No data",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )
                                                : Text(
                                                    _pesoC.toStringAsFixed(2) +
                                                        ' kg');
                                          } else {
                                            return const Center(
                                                child: Text(
                                              "No data",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ));
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 300,
                            bottom: 305,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailView(
                                          cartella: 'secco',
                                          codiceFiscale: _codiceFiscale))),
                              child: Container(
                                width: 125,
                                height: 125,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  gradient: const RadialGradient(
                                    center: Alignment.topRight,
                                    radius: 1.5,
                                    colors: [Colors.white, Colors.grey],
                                  ),
                                  borderRadius: BorderRadius.circular(125),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black38,
                                        spreadRadius: 0,
                                        blurRadius: 10),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Non riciclabili'),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Container(
                                        height: 0.3,
                                        width: 80,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Utenti')
                                            .doc(_codiceFiscale)
                                            .collection('secco')
                                            .orderBy('data', descending: true)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          _pesoS = 0;
                                          if (snapshot.hasData) {
                                            for (var i in snapshot.data!.docs) {
                                              double? _x;
                                              _x = double.tryParse(
                                                  (i.get('peso')));
                                              if (_x != null) {
                                                _pesoS = (_pesoS + _x);
                                              }
                                            }

                                            return snapshot.data!.docs.isEmpty
                                                ? const Center(
                                                    child: Text(
                                                      "No data",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )
                                                : Text(
                                                    _pesoS.toStringAsFixed(2) +
                                                        ' kg');
                                          } else {
                                            return const Center(
                                                child: Text(
                                              "No data",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ));
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 250,
                            bottom: 215,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailView(
                                          cartella: 'vetro',
                                          codiceFiscale: _codiceFiscale))),
                              child: Container(
                                width: 125,
                                height: 125,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  gradient: const RadialGradient(
                                    center: Alignment.topRight,
                                    radius: 1.5,
                                    colors: [Colors.white, Colors.green],
                                  ),
                                  borderRadius: BorderRadius.circular(125),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black38,
                                        spreadRadius: 0,
                                        blurRadius: 10),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Vetro'),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Container(
                                        height: 0.3,
                                        width: 80,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Utenti')
                                            .doc(_codiceFiscale)
                                            .collection('vetro')
                                            .orderBy('data', descending: true)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            _pesoV = 0;
                                            for (var i in snapshot.data!.docs) {
                                              double? _x;
                                              _x = double.tryParse(
                                                  (i.get('peso')));
                                              if (_x != null) {
                                                _pesoV = (_pesoV + _x);
                                              }
                                            }
                                            ;
                                            return snapshot.data!.docs.isEmpty
                                                ? const Center(
                                                    child: Text(
                                                      "No data",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )
                                                : Text(
                                                    _pesoV.toStringAsFixed(2) +
                                                        ' kg',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16));
                                          } else {
                                            return const Center(
                                                child: Text(
                                              "No data",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ));
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      const Text(
                        'Calcolo in tempo reale TARIP:',
                        style:
                            TextStyle(color: Color(0xFF666666), fontSize: 22),
                      ),
                      const Text(
                        '* dati soggetti a cambiamenti da parte del comune tramite delibera',
                        style: TextStyle(color: Colors.red, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              'Totale TARIP ad oggi:',
                              style: TextStyle(
                                  color: Color(0xFF666666), fontSize: 16),
                            ),
                            StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('tasse')
                                    .doc('tasse')
                                    .snapshots(),
                                builder: (context, snapshotTasse) {
                                  _tot = 0;
                                  if (snapshotTasse.hasData) {
                                    double? QuotaFissa;
                                    QuotaFissa = double.tryParse(
                                        snapshotTasse.data!['quota_fissa']);
                                    double? TassaUnariaCarta;
                                    TassaUnariaCarta = double.tryParse(
                                        snapshotTasse
                                            .data!['tassa_unaria_carta']);
                                    double? TassaUnariaPlastica;
                                    TassaUnariaPlastica = double.tryParse(
                                        snapshotTasse
                                            .data!['tassa_unaria_plastica']);
                                    double? TassaUnariaVetro;
                                    TassaUnariaVetro = double.tryParse(
                                        snapshotTasse
                                            .data!['tassa_unaria_vetro']);
                                    double? TassaUnariaUmido;
                                    TassaUnariaUmido = double.tryParse(
                                        snapshotTasse
                                            .data!['tassa_unaria_umido']);
                                    double? TassaUnariaSecco;
                                    TassaUnariaSecco = double.tryParse(
                                        snapshotTasse
                                            .data!['tassa_unaria_secco']);
                                    int? _costoMulta;
                                    _costoMulta = int.tryParse(
                                        snapshotTasse.data!['multa']);

                                    if (QuotaFissa != null &&
                                        TassaUnariaCarta != null &&
                                        TassaUnariaPlastica != null &&
                                        TassaUnariaVetro != null &&
                                        TassaUnariaUmido != null &&
                                        TassaUnariaSecco != null &&
                                        _costoMulta != null) {
                                      _tot = QuotaFissa +
                                          (TassaUnariaCarta * _pesoC) +
                                          (TassaUnariaSecco + _pesoS) +
                                          (TassaUnariaUmido * _pesoU) +
                                          (TassaUnariaVetro * _pesoV) +
                                          (TassaUnariaPlastica * _pesoP);

                                      _multe - 1 > 0
                                          ? _tot = _tot +
                                              ((_multe - 1) * _costoMulta)
                                          : null;
                                      _Quota_fissa = QuotaFissa;
                                      _costoCarta = (TassaUnariaCarta * _pesoC);
                                      _costoSecco = (TassaUnariaSecco + _pesoS);
                                      _costoUmido = (TassaUnariaUmido * _pesoU);
                                      _costoVetro = (TassaUnariaVetro * _pesoV);
                                      _costoPlastica =
                                          (TassaUnariaPlastica * _pesoP);
                                      _multe - 1 > 0
                                          ? _costoMulte =
                                              ((_multe - 1) * _costoMulta)
                                          : null;
                                    }
                                    return !snapshotTasse.data!.exists
                                        ? const Center(
                                            child: Text(
                                              "No data",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )
                                        : Text(_tot.toStringAsFixed(2) + ' €',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16));
                                  } else {
                                    return const Center(
                                        child: Text(
                                      "No data",
                                      style: TextStyle(color: Colors.black),
                                    ));
                                  }
                                })
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Container(
                            height: 0.3,
                            color: const Color(0xFF666666),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              'Stima TARIP al 31/12/2022:',
                              style: TextStyle(
                                  color: Color(0xFF666666), fontSize: 16),
                            ),
                            StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('tasse')
                                    .doc('tasse')
                                    .snapshots(),
                                builder: (context, snapshotTasse) {
                                  _tot2 = 0;
                                  if (snapshotTasse.hasData) {
                                    double? QuotaFissa;
                                    QuotaFissa = double.tryParse(
                                        snapshotTasse.data!['quota_fissa']);
                                    double? TassaUnariaCarta;
                                    TassaUnariaCarta = double.tryParse(
                                        snapshotTasse
                                            .data!['tassa_unaria_carta']);
                                    double? TassaUnariaPlastica;
                                    TassaUnariaPlastica = double.tryParse(
                                        snapshotTasse
                                            .data!['tassa_unaria_plastica']);
                                    double? TassaUnariaVetro;
                                    TassaUnariaVetro = double.tryParse(
                                        snapshotTasse
                                            .data!['tassa_unaria_vetro']);
                                    double? TassaUnariaUmido;
                                    TassaUnariaUmido = double.tryParse(
                                        snapshotTasse
                                            .data!['tassa_unaria_umido']);
                                    double? TassaUnariaSecco;
                                    TassaUnariaSecco = double.tryParse(
                                        snapshotTasse
                                            .data!['tassa_unaria_secco']);

                                    if (QuotaFissa != null &&
                                        TassaUnariaCarta != null &&
                                        TassaUnariaPlastica != null &&
                                        TassaUnariaVetro != null &&
                                        TassaUnariaUmido != null &&
                                        TassaUnariaSecco != null) {
                                      _tot2 = _tot +
                                          (TassaUnariaSecco *
                                              (_mediaS * _molt)) +
                                          (TassaUnariaPlastica *
                                              (_mediaP * _molt)) +
                                          (TassaUnariaVetro *
                                              (_mediaV * _molt)) +
                                          (TassaUnariaCarta *
                                              (_mediaC * _molt)) +
                                          (TassaUnariaUmido *
                                              (_mediaU * _molt * 3));
                                    }
                                    return !snapshotTasse.data!.exists
                                        ? const Center(
                                            child: Text(
                                              "No data",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )
                                        : Text(_tot2.toStringAsFixed(2) + ' €',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16));
                                  } else {
                                    return const Center(
                                        child: Text(
                                      "No data",
                                      style: TextStyle(color: Colors.black),
                                    ));
                                  }
                                })
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Container(
                            height: 0.3,
                            color: const Color(0xFF666666),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('tasse')
                              .doc('tasse')
                              .snapshots(),
                          builder: (context, snapshotTasse) {
                            if (snapshotTasse.hasData) {
                              double? QuotaFissa;
                              QuotaFissa = double.tryParse(
                                  snapshotTasse.data!['quota_fissa']);
                              double? TassaUnariaCarta;
                              TassaUnariaCarta = double.tryParse(
                                  snapshotTasse.data!['tassa_unaria_carta']);
                              double? TassaUnariaPlastica;
                              TassaUnariaPlastica = double.tryParse(
                                  snapshotTasse.data!['tassa_unaria_plastica']);
                              double? TassaUnariaVetro;
                              TassaUnariaVetro = double.tryParse(
                                  snapshotTasse.data!['tassa_unaria_vetro']);
                              double? TassaUnariaUmido;
                              TassaUnariaUmido = double.tryParse(
                                  snapshotTasse.data!['tassa_unaria_umido']);
                              double? TassaUnariaSecco;
                              TassaUnariaSecco = double.tryParse(
                                  snapshotTasse.data!['tassa_unaria_secco']);

                              if (QuotaFissa != null &&
                                  TassaUnariaCarta != null &&
                                  TassaUnariaPlastica != null &&
                                  TassaUnariaVetro != null &&
                                  TassaUnariaUmido != null &&
                                  TassaUnariaSecco != null) {}
                              return !snapshotTasse.data!.exists
                                  ? const Center(
                                      child: Text(
                                        "No data",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18),
                                      child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 230,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Quota fissa:',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 16)),
                                                  Text(
                                                      QuotaFissa.toString() +
                                                          ' €     ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                  child: Container(
                                                    height: 0.1,
                                                    color:
                                                        const Color(0xFF666666),
                                                  )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Carta:',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 16)),
                                                  Text(
                                                      TassaUnariaCarta
                                                              .toString() +
                                                          ' €/Kg',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                  child: Container(
                                                    height: 0.1,
                                                    color:
                                                        const Color(0xFF666666),
                                                  )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Plastica:',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 16)),
                                                  Text(
                                                      TassaUnariaPlastica
                                                              .toString() +
                                                          ' €/kg',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                  child: Container(
                                                    height: 0.1,
                                                    color:
                                                        const Color(0xFF666666),
                                                  )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Vetro:',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 16)),
                                                  Text(
                                                      TassaUnariaVetro
                                                              .toString() +
                                                          ' €/kg',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                  child: Container(
                                                    height: 0.1,
                                                    color:
                                                        const Color(0xFF666666),
                                                  )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Organico:',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 16)),
                                                  Text(
                                                      TassaUnariaUmido
                                                              .toString() +
                                                          ' €/kg',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                  child: Container(
                                                    height: 0.1,
                                                    color:
                                                        const Color(0xFF666666),
                                                  )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Secco:',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 16)),
                                                  Text(
                                                      TassaUnariaSecco
                                                              .toString() +
                                                          ' €/kg',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                  child: Container(
                                                    height: 0.3,
                                                    color:
                                                        const Color(0xFF666666),
                                                  )),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                            ],
                                          )),
                                    );
                            } else {
                              return const Center(
                                  child: Text(
                                "No data",
                                style: TextStyle(color: Colors.black),
                              ));
                            }
                          }),
                      FutureBuilder<void>(
                          future: Future.delayed(const Duration(
                              seconds:
                                  3)), // a previously-obtained Future<String> or null
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            return SizedBox(height: 300, child: _grafico());
                          }),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            );

  Widget _grafico() {
    List<_ChartData> data = [
      _ChartData('Carta', _costoCarta, Colors.blue),
      _ChartData('Plastica', _costoPlastica, Colors.yellow),
      _ChartData('Non riciclabile', _costoSecco, Colors.grey),
      _ChartData('Organico', _costoUmido, Colors.brown),
      _ChartData('Vetro', _costoVetro, Colors.green),
      _ChartData('Multe', _costoMulte.toDouble(), Colors.red),
      _ChartData('Quota fissa', _Quota_fissa, Colors.black),
    ];
    TooltipBehavior _tooltip = TooltipBehavior(enable: true);
    return SfCartesianChart(
        key: ValueKey(_costoCarta),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(minimum: 0, maximum: _tot, interval: 5),
        tooltipBehavior: _tooltip,
        series: <ChartSeries<_ChartData, String>>[
          BarSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              name: 'Gold',
              pointColorMapper: (_ChartData data, _) => data.color)
        ]);
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color? color;
}
