import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:intl/intl.dart';

class SessionView extends StatefulWidget {
  final String codiceFiscale;
  const SessionView({Key? key, required this.codiceFiscale}) : super(key: key);

  @override
  State<SessionView> createState() => _SessionViewState();
}

TextEditingController _pesoController = TextEditingController();
int _index = 0;
bool _aggiorna = false;
String _scanCodiceFiscale = '';
bool isSwitched = false;
final formKey = GlobalKey<FormState>();

bool _progres = false;

String codiceFiscale = '';
String _giorno = '';

DateTime ordine = DateTime(1900);
bool consegnaAvvenuta = false;

class _SessionViewState extends State<SessionView> {
  Future<void> scanBarcodeNormal(bool _normale, String id) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    if (_normale) {
      _chek = await getCodiceFiscale(barcodeScanRes);
      setState(() {
        _scanCodiceFiscale = barcodeScanRes;
        _cambiato = true;
        _valido = _chek == '' ? false : true;
      });
      return;
    } else {
      setState(() {
        _scanCodiceFiscale = barcodeScanRes;
        _cambiato = true;
      });
      await checkOTP(id, barcodeScanRes);
    }
  }

  void cambia_stato(bool nuovo) {
    setState(() => _aggiorna = nuovo);
  }

  @override
  void initState() {
    setState(() {
      codiceFiscale = widget.codiceFiscale;
    });

    setState(
        () => _giorno = DateFormat('EEEE').format(DateTime.now()).toString());

    super.initState();
  }

  Future checkOTP(String cf, String OTP) async {
    var collection = FirebaseFirestore.instance.collection('Utenti');
    var docSnapshot = await collection
        .doc(cf.toUpperCase())
        .collection('codice_ritiro')
        .doc('codice')
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      // You can then retrieve the value from the Map like this:
      var value = data?['data'] as Timestamp;
      var value1 = data?['codice'];
      if (value
          .toDate()
          .isBefore((DateTime.now().subtract(const Duration(days: 1))))) {
        setState(() {
          _valido = false;
        });
        return;
      } else {
        if (value1 == OTP) {
          setState(() {
            _valido = true;
          });
          return;
        } else {
          setState(() {
            _valido = false;
          });
          return;
        }
      }
    } else {
      setState(() {
        _valido = false;
      });
      return;
    }
  }

  String _chek = '';
  bool _valido = false;
  bool _cambiato = false;
  int _key = 0;

  Widget _info() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ritiroIngombranti')
            .doc(DateTime.now().day.toString() +
                '-' +
                DateTime.now().month.toString() +
                '-' +
                DateTime.now().year.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.exists
                ? FutureBuilder<List<String>>(
                    future:
                        _getInfo(), // a previously-obtained Future<String> or
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snap) {
                      List<Widget> children;
                      if (snap.hasData) {
                        if (snap.data!.length == 5) {
                          children = <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Consegne restanti:'),
                                    Text(snap.data![4])
                                  ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Codice Fiscale:'),
                                    Text(snap.data![0])
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Nome:'),
                                    Text(snap.data![1])
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Cognome:'),
                                    Text(snap.data![2])
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Indirizzo:'),
                                    Text(snap.data![3])
                                  ]),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 45),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(_index == 0
                                      ? 'Codice a barre:    ' +
                                          _scanCodiceFiscale
                                      : 'Codice a barre OTP:    ' +
                                          _scanCodiceFiscale),
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.90,
                                child: InkWell(
                                  onTap: () {
                                    scanBarcodeNormal(false, snap.data![0]);
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text(
                                            'Inquadra codice a barre',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(width: 10),
                                          Icon(
                                            Icons.photo_camera,
                                            color: Colors.white,
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if (_scanCodiceFiscale == '') return;
                                if (_valido) {
                                  writeIngombranti(snap.data![0]);
                                  setState(() {
                                    _pesoController.clear();
                                    _valido = false;
                                    _cambiato = false;

                                    _scanCodiceFiscale = '';
                                    isSwitched = false;
                                    _progres = false;
                                  });
                                }
                              },
                              child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: (_valido
                                          ? Colors.blue
                                          : Colors.grey)),
                                  child: const Center(
                                    child: Text(
                                      'Esegui Conferimento',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            )
                          ];
                        } else {
                          children = <Widget>[
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 60,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                  'Errore non sono riuscito a caricare tutti i dati'),
                            )
                          ];
                        }
                      } else if (snapshot.hasError) {
                        children = <Widget>[
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snap.error}'),
                          )
                        ];
                      } else {
                        children = const <Widget>[
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Sto scaricando i dati...'),
                          )
                        ];
                      }
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ));
                    })
                : const Center(
                    child: Text('Non ci sono ritiri previsti per oggi'),
                  );
          } else {
            return const Center(
              child: Text('Errore nel sistema'),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          HapticFeedback.lightImpact();
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Gestione raccolta'),
          ),
          body: _progres
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  key: ValueKey(_key),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _index = 0;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: _index == 0
                                                    ? const Color(0xFF87b837)
                                                    : Colors.transparent,
                                                width: 1.2))),
                                    height: 20,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        'Raccolta ordinaria',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: _index == 0
                                                ? FontWeight.w600
                                                : FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _index = 1;

                                      _pesoController.clear();
                                      _valido = false;
                                      _cambiato = false;

                                      _scanCodiceFiscale = '';
                                      isSwitched = false;
                                      _progres = false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: _index == 1
                                                    ? const Color(0xFF87b837)
                                                    : Colors.transparent,
                                                width: 1.2))),
                                    height: 20,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        'Raccolta ingombranti',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: _index == 1
                                                ? FontWeight.w600
                                                : FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _index == 1
                              ? _info()
                              : _giorno == 'Monday'
                                  ? const Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        'Raccolta Secco',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    )
                                  : _giorno == 'Tuesday'
                                      ? const Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            'Raccolta Rifiuti Organici',
                                            style: TextStyle(fontSize: 24),
                                          ))
                                      : _giorno == 'Wednesday'
                                          ? const Align(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                'Raccolta Plastica e Lattine',
                                                style: TextStyle(fontSize: 24),
                                              ))
                                          : _giorno == 'Thursday'
                                              ? const Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    'Raccolta Carta e Cartone',
                                                    style:
                                                        TextStyle(fontSize: 24),
                                                  ))
                                              : _giorno == 'Friday'
                                                  ? const Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Text(
                                                        'Raccolta Rifiuti Organici',
                                                        style: TextStyle(
                                                            fontSize: 24),
                                                      ))
                                                  : _giorno == 'Sunday'
                                                      ? const Align(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          child: Text(
                                                              'Raccolta Secco'))
                                                      : const Align(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          child: Text(
                                                            'Raccolta Plastica e Lattine',
                                                            style: TextStyle(
                                                                fontSize: 24),
                                                          )),
                          const SizedBox(
                            height: 30,
                          ),
                          _index == 0
                              ? Row(
                                  children: [
                                    const Text(
                                      'Peso:',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                        width: 100,
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (peso) =>
                                              double.tryParse(peso!) == null
                                                  ? 'Inserisci numeri corretti'
                                                  : null,
                                          autocorrect: false,
                                          controller: _pesoController,
                                          cursorColor: Colors.white,
                                          textInputAction: TextInputAction.done,
                                          decoration: const InputDecoration(
                                              labelText: 'peso'),
                                        )),
                                    const Text(
                                      ' Kg',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          _index == 1
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 50),
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(top: 55),
                                  child: SizedBox()),
                          _index == 0
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(_index == 0
                                      ? 'Codice a barre:    ' +
                                          _scanCodiceFiscale
                                      : 'Codice a barre OTP:    ' +
                                          _scanCodiceFiscale),
                                )
                              : SizedBox(),
                          _index == 0
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 45),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    child: InkWell(
                                      onTap: () {
                                        scanBarcodeNormal(true, '');
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.blue),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text(
                                                'Inquadra codice a barre',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.photo_camera,
                                                color: Colors.white,
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          _index == 0
                              ? _cambiato
                                  ? _valido == false
                                      ? const Text(
                                          'Codice a barre non trovato',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : const Text('')
                                  : const Text('')
                              : SizedBox(),
                          _index == 0
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 55),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                          'Il conferimento non è conforme'),
                                      Switch(
                                        value: isSwitched,
                                        onChanged: (value) {
                                          setState(() {
                                            isSwitched = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ))
                              : const SizedBox(),
                          const SizedBox(
                            height: 20,
                          ),
                          _index == 0
                              ? InkWell(
                                  onTap: () async {
                                    if (_valido) {
                                      final isValid =
                                          formKey.currentState!.validate();
                                      if (!isValid) return;
                                      if (_scanCodiceFiscale == '') return;
                                      setState(() => _progres = true);
                                      String _s = await getCodiceFiscale(
                                          _scanCodiceFiscale);
                                      if (_s.isEmpty) return;
                                      await write(_s, _scanCodiceFiscale);
                                      isSwitched
                                          ? await message(
                                              await getCodiceFiscale(
                                                  _scanCodiceFiscale))
                                          : null;
                                      setState(() {
                                        _pesoController.clear();
                                        _scanCodiceFiscale = '';
                                        isSwitched = false;
                                        _progres = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: (_valido &&
                                                  _pesoController.text != ''
                                              ? Colors.blue
                                              : Colors.grey)),
                                      child: const Center(
                                        child: Text(
                                          'Esegui Conferimento',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<String> getCodiceFiscale(String codiceBarre) async {
    String _utente = '';
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot query = await _firestore.collection('Utenti').get();

    if (query.docs.isNotEmpty) {
      query.docs.forEach((element) {
        if ((element.get('sacchetti') as List).contains(codiceBarre)) {
          setState(() {
            _utente = element.id;
          });
        }
      });
    }
    return _utente;
  }

  Future writeIngombranti(String codiceFiscale) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference docRef = _firestore
        .collection('Utenti')
        .doc(codiceFiscale)
        .collection('ingombranti')
        .doc();

    WriteBatch write = _firestore.batch();

    write.set(docRef, {
      'data': DateTime.now(),
    });
    write.commit();
  }

  Future write(String codiceFiscale, String codiceBarre) async {
    String day = _giorno == 'Monday'
        ? 'secco'
        : _giorno == 'Tuesday'
            ? 'organico'
            : _giorno == 'Wednesday'
                ? 'plastica'
                : _giorno == 'Thursday'
                    ? 'carta'
                    : _giorno == 'Friday'
                        ? 'umido'
                        : _giorno == 'Sunday'
                            ? 'secco'
                            : 'plastica';
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference docRef = _firestore
        .collection('Utenti')
        .doc(codiceFiscale)
        .collection(day)
        .doc();

    WriteBatch write = _firestore.batch();

    write.set(docRef, {
      'data': DateTime.now(),
      'peso': _pesoController.text.trim(),
      'segnalata': isSwitched
    });
    write.commit();

    FirebaseFirestore.instance
        .collection('ritiroIngombranti')
        .doc(DateTime.now().day.toString() +
            '-' +
            DateTime.now().month.toString() +
            '-' +
            DateTime.now().year.toString())
        .collection('tickets')
        .doc(codiceFiscale)
        .delete();
  }

  Future message(String codiceFiscale) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference docRef = _firestore
        .collection('Utenti')
        .doc(codiceFiscale)
        .collection('messaggi')
        .doc();

    WriteBatch write = _firestore.batch();

    write.set(docRef, {
      'data': DateTime.now(),
      'body': 'Il tuo conferimento di oggi è stato segnalato',
    });
    write.commit();
  }
}

Future<List<String>> _getInfo() async {
  List<String> _info = [];
  var collection = FirebaseFirestore.instance
      .collection('ritiroIngombranti')
      .doc(DateTime.now().day.toString() +
          '-' +
          DateTime.now().month.toString() +
          '-' +
          DateTime.now().year.toString())
      .collection('tickets');
  var docSnapshot = await collection.get();
  if (docSnapshot.docs.isNotEmpty) {
    for (var i in docSnapshot.docs) {
      if (i.id != '0') {
        if (i.get('ritirato') == false) {
          _info.add(i.id);
          _info.add(i.get('nome'));
          _info.add(i.get('cognome'));
          _info.add(i.get('indirizzo'));
          _info.add((docSnapshot.docs.length - 1).toString());
          return _info;
        }
      }
    }
  }
  return [];
}
