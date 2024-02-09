import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sistema_gestione_comune/service/sacchetti.dart';
import 'package:sistema_gestione_comune/service/transazioni_sacchetti.dart';

class ConsegnaSacchetti extends StatefulWidget {
  final ValueChanged<bool> aggiorna_stato;
  final String addetto;
  const ConsegnaSacchetti(
      {Key? key, required this.aggiorna_stato, required this.addetto})
      : super(key: key);

  @override
  State<ConsegnaSacchetti> createState() => _ConsegnaSacchettiState();
}

class _ConsegnaSacchettiState extends State<ConsegnaSacchetti> {
  String _scanCodiceFiscale = '';
  String _scanCodiceaBarre = '';
  String _scanOTP = '';
  final TextEditingController _controlle = TextEditingController();
  final TextEditingController _controllerBarre = TextEditingController();
  final TextEditingController _controllerOTP = TextEditingController();
  String _messaggio_informativo = '';
  String _messaggio_informativoOTP = '';
  bool fine = false;
  bool _InserisciCodiceManualmente = false;
  bool _InserisciCodiceFiscaleManualmente = false;
  bool _InserisciCodiceManualmenteOTP = false;

  int _step = 0;
  Future<void> scanBarcodeNormal(int i) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    i == 1
        ? setState(() {
            _controlle.text = barcodeScanRes;
            _scanCodiceFiscale = barcodeScanRes;
          })
        : i == 0
            ? setState(() {
                _controllerBarre.text = barcodeScanRes;
                _scanCodiceaBarre = barcodeScanRes;
              })
            : setState(() {
                _controllerOTP.text = barcodeScanRes;
                _scanOTP = barcodeScanRes;
              });
  }

  Future<String> checkOTP(String cf, String OTP) async {
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
          _messaggio_informativoOTP = 'CODICE SCADUTO';
        });
        return _messaggio_informativoOTP;
      } else {
        if (value1 == OTP) {
          setState(() {
            _messaggio_informativoOTP = 'AUTORIZZATO';
          });
          return _messaggio_informativoOTP;
        } else {
          setState(() {
            _messaggio_informativoOTP = 'NON AUTORIZZATO';
          });
          return _messaggio_informativoOTP;
        }
      }
    } else {
      setState(() {
        _messaggio_informativoOTP = 'CODICE NON TROVATO';
      });
      return _messaggio_informativoOTP;
    }
  }

  Future<String> check(String cf) async {
    var collection = FirebaseFirestore.instance.collection('Utenti');
    var docSnapshot = await collection.doc(cf).get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      // You can then retrieve the value from the Map like this:
      var value = data?['ultimoRitiro'] as Timestamp;
      if (value
          .toDate()
          .isBefore((DateTime.now().subtract(const Duration(days: 7))))) {
        setState(() {
          _messaggio_informativo = 'AUTORIZZATO';
        });
        return _messaggio_informativo;
      } else {
        setState(() {
          _messaggio_informativo = 'NON AUTORIZZATO';
        });
        return _messaggio_informativo;
      }
    } else {
      setState(() {
        _messaggio_informativo = 'UTENTE INESISTENTE';
      });
      return _messaggio_informativo;
    }
  }

  List<Widget> children = <Widget>[
    const Icon(
      Icons.check_circle_outline,
      color: Colors.green,
      size: 60,
    ),
    const Padding(
      padding: EdgeInsets.only(top: 16),
      child: Text('Operazione effettuata con successo.'),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Consegna sacchetti',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: fine
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ))
            : SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _step == 0
                          ? Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 18, top: 50),
                                    child: Text(
                                      'Step 1:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _InserisciCodiceManualmente = false;
                                        });
                                        scanBarcodeNormal(0);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                                'Inquadra codice  a barre',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Icon(
                                                Icons.photo_camera,
                                                color: Colors.white,
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _InserisciCodiceManualmente =
                                              _InserisciCodiceManualmente
                                                  ? false
                                                  : true;
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: _InserisciCodiceManualmente
                                                ? Colors.grey
                                                : Colors.blue),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text(
                                                'Inserisci manualmente',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Icon(
                                                Icons.keyboard,
                                                color: Colors.white,
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 75,
                                  child: _InserisciCodiceManualmente
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 15),
                                          child: TextFormField(
                                              controller: _controllerBarre,
                                              decoration: const InputDecoration(
                                                  hintText: 'Codice a barre'),
                                              validator: (value) {},
                                              onChanged: (value) {
                                                setState(() {
                                                  _scanCodiceaBarre = value;
                                                });
                                              }),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 15),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Codice a barre:     $_scanCodiceaBarre',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                ),
                                _scanCodiceaBarre.isNotEmpty
                                    ? Align(
                                        alignment: Alignment.topCenter,
                                        child: InkWell(
                                          onTap: () {
                                            if (_scanCodiceaBarre.isNotEmpty) {
                                              setState(() {
                                                _step = 1;
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.90,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color:
                                                    _scanCodiceaBarre.isNotEmpty
                                                        ? Colors.green
                                                        : Colors.transparent),
                                            child: Center(
                                              child: Text(
                                                'Avanti',
                                                style: TextStyle(
                                                    color: _scanCodiceaBarre
                                                            .isNotEmpty
                                                        ? Colors.white
                                                        : Colors.transparent,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 75,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Codice a barre:     $_scanCodiceaBarre',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      _step == 0
                          ? Container()
                          : _step == 1
                              ? Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 18, top: 50),
                                        child: Text(
                                          'Step 2:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 22),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 18),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.90,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _InserisciCodiceFiscaleManualmente =
                                                  false;
                                            });
                                            scanBarcodeNormal(1);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                    'Inquadra codice fiscale',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.photo_camera,
                                                    color: Colors.white,
                                                  )
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.90,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _InserisciCodiceFiscaleManualmente =
                                                  _InserisciCodiceFiscaleManualmente
                                                      ? false
                                                      : true;
                                            });
                                            scanBarcodeNormal(1);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color:
                                                    _InserisciCodiceFiscaleManualmente
                                                        ? Colors.grey
                                                        : Colors.blue),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Text(
                                                    'Inserisci codice fiscale manualemete',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.keyboard,
                                                    color: Colors.white,
                                                  )
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 75,
                                      child: _InserisciCodiceFiscaleManualmente
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 15),
                                              child: TextFormField(
                                                  controller: _controlle,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              'Codice Fiscale'),
                                                  validator: (value) {},
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _scanCodiceFiscale =
                                                          value;
                                                    });
                                                  }),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 15),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Codice Fiscale:     $_scanCodiceFiscale',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 25),
                                        child: Text(
                                          _messaggio_informativo,
                                          style: TextStyle(
                                              color: _messaggio_informativo ==
                                                      'AUTORIZZATO'
                                                  ? Colors.green
                                                  : _messaggio_informativo ==
                                                          'NON AUTORIZZATO'
                                                      ? Colors.red
                                                      : Colors.amber,
                                              fontSize: 18),
                                        )),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: InkWell(
                                        onTap: () async {
                                          if (_scanCodiceFiscale.isNotEmpty) {
                                            if (await check(_scanCodiceFiscale
                                                    .toUpperCase()) ==
                                                'AUTORIZZATO') {
                                              setState(() {
                                                _step = 2;
                                              });
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  _scanCodiceFiscale.isNotEmpty
                                                      ? Colors.blue
                                                      : Colors.transparent),
                                          child: Center(
                                            child: Text(
                                              'Verifica',
                                              style: TextStyle(
                                                  color: _scanCodiceFiscale
                                                          .isNotEmpty
                                                      ? Colors.white
                                                      : Colors.transparent,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 75,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Codice Fiscale:     $_scanCodiceFiscale',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                      _step == 0 || _step == 1
                          ? Container()
                          : Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 18, top: 50),
                                    child: Text(
                                      'Step 3:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _InserisciCodiceManualmenteOTP =
                                              false;
                                        });
                                        scanBarcodeNormal(2);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                                'Inquadra codice a barre OTP',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Icon(
                                                Icons.photo_camera,
                                                color: Colors.white,
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _InserisciCodiceManualmenteOTP =
                                              _InserisciCodiceManualmenteOTP
                                                  ? false
                                                  : true;
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                _InserisciCodiceManualmenteOTP
                                                    ? Colors.grey
                                                    : Colors.blue),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text(
                                                'Inserisci manualmente',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Icon(
                                                Icons.keyboard,
                                                color: Colors.white,
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 75,
                                  child: _InserisciCodiceManualmenteOTP
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 15),
                                          child: TextFormField(
                                              controller: _controllerOTP,
                                              decoration: const InputDecoration(
                                                  hintText: 'Codice a barre'),
                                              validator: (value) {},
                                              onChanged: (value) {
                                                setState(() {
                                                  _scanOTP = value;
                                                });
                                              }),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 15),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Codice OTP:     $_scanOTP',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25),
                                    child: Text(
                                      _messaggio_informativoOTP,
                                      style: TextStyle(
                                          color: _messaggio_informativoOTP ==
                                                  'AUTORIZZATO'
                                              ? Colors.green
                                              : _messaggio_informativoOTP ==
                                                      'NON AUTORIZZATO'
                                                  ? Colors.red
                                                  : Colors.amber,
                                          fontSize: 18),
                                    )),
                                _scanOTP.isNotEmpty
                                    ? Align(
                                        alignment: Alignment.topCenter,
                                        child: InkWell(
                                          onTap: () async {
                                            if (_scanOTP.isNotEmpty) {
                                              if (await checkOTP(
                                                          _scanCodiceFiscale,
                                                          _scanOTP) ==
                                                      'AUTORIZZATO' &&
                                                  _messaggio_informativo ==
                                                      'AUTORIZZATO') {
                                                decrementSacchetti();
                                                widget.aggiorna_stato(true);
                                                transazioneSacchetti(
                                                    _scanCodiceFiscale,
                                                    widget.addetto,
                                                    _scanCodiceaBarre);
                                                assegnaSacchetti(
                                                    _scanCodiceFiscale,
                                                    _scanCodiceaBarre);

                                                setState(() {
                                                  fine = true;
                                                });
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.90,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: _scanOTP.isNotEmpty
                                                    ? Colors.green
                                                    : Colors.transparent),
                                            child: Center(
                                              child: Text(
                                                'Consegna',
                                                style: TextStyle(
                                                    color: _scanOTP.isNotEmpty
                                                        ? Colors.white
                                                        : Colors.transparent,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                      const Spacer()
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
