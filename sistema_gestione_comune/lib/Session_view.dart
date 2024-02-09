import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistema_gestione_comune/Consegna_sacchetti_view.dart';
import 'package:sistema_gestione_comune/Session_cubit.dart';
import 'package:sistema_gestione_comune/gestione_ingombranti.dart';
import 'package:sistema_gestione_comune/service/sacchetti.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SessionView extends StatefulWidget {
  final String codiceFiscale;
  const SessionView({Key? key, required this.codiceFiscale}) : super(key: key);

  @override
  State<SessionView> createState() => _SessionViewState();
}

bool _aggiorna = false;
int progressValue = 0;
String codiceFiscale = '';

DateTime ordine = DateTime(1900);
bool consegnaAvvenuta = false;

bool caricamento_ordine = false;

class _SessionViewState extends State<SessionView> {
  bool _calcolo_fatture = false;
  void cambia_stato(bool nuovo) {
    setState(() => _aggiorna = nuovo);
  }

  @override
  void initState() {
    Future.delayed((Duration.zero), () {
      getNumeroSacchetti().then((value) {
        setState(() {
          progressValue = value;
        });
      });
    });
    Future.delayed((Duration.zero), () {
      getOrdine().then((value) {
        setState(() {
          ordine = value;
        });
      });
    });
    Future.delayed((Duration.zero), () {
      getConferma().then((value) {
        setState(() {
          consegnaAvvenuta = value;
        });
      });
    });
    setState(() {
      codiceFiscale = widget.codiceFiscale;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_aggiorna) {
      cambia_stato(false);
      Future.delayed((const Duration(seconds: 2)), () {
        getNumeroSacchetti().then((value) {
          setState(() {
            progressValue = value;
          });
        });
      });
      Future.delayed((const Duration(seconds: 2)), () {
        getOrdine().then((value) {
          setState(() {
            ordine = value;
          });
        });
      });
      Future.delayed((const Duration(seconds: 2)), () {
        getConferma().then((value) {
          setState(() {
            consegnaAvvenuta = value;
          });
        });
      });
    }

    if (caricamento_ordine) {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          caricamento_ordine = false;
        });
      });
    }
    return Scaffold(
      body: SafeArea(
        child: caricamento_ordine
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _calcolo_fatture
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Invio fatture in corso...'),
                          Text('$indice / $totali'),
                          CircularProgressIndicator()
                        ]),
                  )
                : SingleChildScrollView(
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'UnComune',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 35),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Addetto: $codiceFiscale'.toUpperCase()),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('Sacchetti disponibili:'),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 4,
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    showLabels: false,
                                    showTicks: false,
                                    axisLineStyle: const AxisLineStyle(
                                      thickness: 0.2,
                                      cornerStyle: CornerStyle.bothCurve,
                                      color: Color.fromARGB(30, 0, 169, 181),
                                      thicknessUnit: GaugeSizeUnit.factor,
                                    ),
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                          positionFactor: 0.1,
                                          angle: 90,
                                          widget: Center(
                                              child: Column(
                                            children: [
                                              const Spacer(),
                                              Text(
                                                progressValue
                                                        .toStringAsFixed(0) +
                                                    ' / 100',
                                                style: const TextStyle(
                                                    fontSize: 35),
                                              ),
                                              Text(
                                                ordine.compareTo(DateTime
                                                                .now()) >
                                                            0 &&
                                                        !consegnaAvvenuta
                                                    ? 'in arrivo: ' +
                                                        ordine.day.toString() +
                                                        '-' +
                                                        ordine.month
                                                            .toString() +
                                                        '-' +
                                                        ordine.year.toString()
                                                    : '',
                                                style: const TextStyle(
                                                    color: Colors.amber),
                                              ),
                                              const Spacer(),
                                            ],
                                          )))
                                    ],
                                    pointers: <GaugePointer>[
                                      RangePointer(
                                        value: progressValue.toDouble(),
                                        cornerStyle: CornerStyle.bothCurve,
                                        width: 0.2,
                                        sizeUnit: GaugeSizeUnit.factor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ConsegnaSacchetti(
                                                aggiorna_stato: cambia_stato,
                                                addetto: codiceFiscale,
                                              )));
                                },
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                      child: Text(
                                        'CONSEGNA SACCHETTI',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ))),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GestioneIngombrantiView()));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Text(
                                    'GESTIONE RITIRO INGOMBRANTI',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            /*  InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  width: 100,
                                  height: 75,
                                  child: TextFormField(
                                      controller: _controller,
                                      keyboardType: TextInputType.phone,
                                      decoration:
                                          const InputDecoration(hintText: ''),
                                      validator: (value) {},
                                      onChanged: (value) {
                                        setState(() {
                                          _numeroDaAggiungere =
                                              int.tryParse(value) ?? 0;
                                        });
                                      }),
                                ),
                                ElevatedButton(
                                  child: const Text('Aggiungi sacchetti'),
                                  onPressed: () {
                                    aggiungiSacchetti(_numeroDaAggiungere);
                                    setState(() {
                                      _controller.text = '0';
                                      _numeroDaAggiungere = 0;
                                      _aggiorna = true;
                                    });

                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        'AGGIUNGI SACCHETTI',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ))),*/
                            InkWell(
                              onTap: () {
                                if (progressValue < 45) {
                                  if (consegnaAvvenuta) {
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 200,
                                            color: Colors.white,
                                            child: caricamento_ordine
                                                ? const CircularProgressIndicator()
                                                : Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        SizedBox(
                                                            width: 300,
                                                            height: 100,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text('Vuoi inviare un ordine di ' +
                                                                    (100 - progressValue)
                                                                        .toString() +
                                                                    ' sacchetti?'),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'ANNULLA',
                                                                          style:
                                                                              TextStyle(color: Colors.red),
                                                                        )),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            caricamento_ordine =
                                                                                true;
                                                                            _aggiorna =
                                                                                true;
                                                                          });
                                                                          cambiaStatoConferma(
                                                                              false);
                                                                          cambiaArrivo();
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'CONFERMA',
                                                                          style:
                                                                              TextStyle(color: Colors.blue),
                                                                        ))
                                                                  ],
                                                                )
                                                              ],
                                                            )),
                                                        /* ElevatedButton(
                                  child: const Text('Aggiungi sacchetti'),
                                  onPressed: () {
                                    aggiungiSacchetti(_numeroDaAggiungere);
                                    setState(() {
                                      _controller.text = '0';
                                      _numeroDaAggiungere = 0;
                                      _aggiorna = true;
                                    });

                                    Navigator.pop(context);
                                  },
                                )*/
                                                      ],
                                                    ),
                                                  ),
                                          );
                                        });
                                  } else {
                                    aggiungiSacchetti(100 - progressValue);
                                    cambiaStatoConferma(true);

                                    setState(() {
                                      caricamento_ordine = true;
                                      _aggiorna = true;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: progressValue >= 45
                                        ? Colors.grey
                                        : consegnaAvvenuta
                                            ? Colors.blue
                                            : Colors.amber,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    consegnaAvvenuta
                                        ? 'ORDINA SACCHETTI'
                                        : 'COFERMA CONSEGNA',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Invio Fatture'),
                                    content: Text(
                                        'Sei sicuro di voler inviare le fatture?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          invioFatture();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Si'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Text(
                                    'INVIA FATTURE',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                                onPressed: () =>
                                    BlocProvider.of<SessionCubit>(context)
                                        .signOut(),
                                child: const Text('Sign out')),
                          ]),
                    ),
                  ),
      ),
    );
  }

  int indice = 0;
  int totali = 0;
  Future invioFatture() async {
    indice = 0;
    totali = 0;
    setState(() {
      _calcolo_fatture = true;
    });
    double TassaUnariaCarta = 0.0;
    double TassaUnariaPlastica = 0.0;
    double TassaUnariaVetro = 0.0;
    double TassaUnariaUmido = 0.0;
    double TassaUnariaSecco = 0.0;
    int _costoMulta = 0;
    double QuotaFissa = 0.0;
    var t = FirebaseFirestore.instance.collection('tasse').doc('tasse');
    var ts = await t.get();

    if (ts.exists) {
      QuotaFissa;
      QuotaFissa = double.tryParse(ts.get('quota_fissa')) ?? -1000.0;
      TassaUnariaCarta;
      TassaUnariaCarta =
          double.tryParse(ts.get('tassa_unaria_carta')) ?? -1000.0;
      TassaUnariaPlastica;
      TassaUnariaPlastica =
          double.tryParse(ts.get('tassa_unaria_plastica')) ?? -1000.0;
      TassaUnariaVetro;
      TassaUnariaVetro =
          double.tryParse(ts.get('tassa_unaria_vetro')) ?? -1000.0;
      TassaUnariaUmido;
      TassaUnariaUmido =
          double.tryParse(ts.get('tassa_unaria_umido')) ?? -1000.0;
      TassaUnariaSecco;
      TassaUnariaSecco =
          double.tryParse(ts.get('tassa_unaria_secco')) ?? -1000.0;
      _costoMulta;
      _costoMulta = int.tryParse(ts.get('multa')) ?? 0;
    } else {
      print('problema');
      return;
    }

    var c = FirebaseFirestore.instance.collection('Utenti');
    var s = await c.get();
    if (s.docs.isNotEmpty) {
      setState(() {
        totali = s.docs.length;
      });
      for (var utente in s.docs) {
        setState(() {
          indice = indice + 1;
        });
        double tot = 0.0;
        double _pesoC = 0.0;
        double _multe = 0.0;
        double _pesoP = 0.0;
        double _pesoS = 0.0;
        double _pesoV = 0.0;
        double _pesoU = 0.0;

        var collection = FirebaseFirestore.instance
            .collection('Utenti')
            .doc(utente.id)
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
          }
        }
        collection = FirebaseFirestore.instance
            .collection('Utenti')
            .doc(utente.id)
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
          }
        }

        collection = FirebaseFirestore.instance
            .collection('Utenti')
            .doc(utente.id)
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
          }
        }

        collection = FirebaseFirestore.instance
            .collection('Utenti')
            .doc(utente.id)
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
          }
        }

        collection = FirebaseFirestore.instance
            .collection('Utenti')
            .doc(utente.id)
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
          }
        }

        tot = QuotaFissa +
            (TassaUnariaCarta * _pesoC) +
            (TassaUnariaSecco + _pesoS) +
            (TassaUnariaUmido * _pesoU) +
            (TassaUnariaVetro * _pesoV) +
            (TassaUnariaPlastica * _pesoP);

        _multe - 1 > 0 ? tot = tot + ((_multe - 1) * _costoMulta) : null;

        FirebaseFirestore _firestore7 = FirebaseFirestore.instance;
        var docRef7 = _firestore7
            .collection('Utenti')
            .doc(utente.id)
            .collection('fatture');
        docRef7.add({
          'emissione': DateTime.now(),
          'importo': tot.toStringAsFixed(2),
          'scadenza': DateTime.now().add(const Duration(days: 21)),
          'stato': false,
        });
      }
    }

    setState(() {
      _calcolo_fatture = false;
    });
  }
}
