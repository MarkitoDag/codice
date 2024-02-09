import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messaggi extends StatefulWidget {
  const Messaggi({Key? key}) : super(key: key);

  @override
  State<Messaggi> createState() => _MessaggiState();
}

class _MessaggiState extends State<Messaggi> {
  int _index = 0;
  String _codiceFiscale = '';
  bool _finito = false;
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

  @override
  void initState() {
    getUtente().then((value) => setState(() {
          _codiceFiscale = value;
          _finito = true;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => !_finito
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Centro messaggi',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
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
                          width: MediaQuery.of(context).size.width / 4,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Avvisi',
                              style: TextStyle(
                                  fontSize: 14,
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
                          width: MediaQuery.of(context).size.width / 4,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Sacchetti',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: _index == 1
                                      ? FontWeight.w600
                                      : FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _index = 2;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: _index == 2
                                          ? const Color(0xFF87b837)
                                          : Colors.transparent,
                                      width: 1.2))),
                          height: 20,
                          width: MediaQuery.of(context).size.width / 4,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Fatture',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: _index == 2
                                      ? FontWeight.w600
                                      : FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 180,
                    child: _index == 0
                        ? _avvisi()
                        : _index == 1
                            ? _sacchetti()
                            : _fattur())
              ],
            ),
          ),
        );

  Widget _avvisi() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Utenti')
          .doc(_codiceFiscale)
          .collection('messaggi')
          .orderBy('data', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.docs.isEmpty
              ? const Center(
                  child: Text(
                    "Non ci sono messaggi",
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
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    Timestamp t = doc['data'];
                    DateTime d = t.toDate();
                    return Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              d.day.toString() +
                                  '/' +
                                  d.month.toString() +
                                  '/' +
                                  d.year.toString(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              width: 100,
                              height: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            doc['body'],
                            style: const TextStyle(
                                wordSpacing: 2,
                                letterSpacing: 0,
                                leadingDistribution:
                                    TextLeadingDistribution.proportional),
                          ),
                        ],
                      ),
                    );
                  });
        } else {
          return const Center(child: Text("No data"));
        }
      },
    );
  }

  Future<List<_Transazioni>> _getSacchietti() async {
    List<_Transazioni> _t = [];
    var collection =
        FirebaseFirestore.instance.collection('consegna_sacchetti');
    var docSnapshot = await collection.get();
    if (docSnapshot.docs.isNotEmpty) {
      for (var i in docSnapshot.docs) {
        if (i['richiedente'] == _codiceFiscale) {
          _t.add(_Transazioni(
              i['richiedente'], i['addetto'], i['codice'], i['data']));
        }
      }
    }
    _t.sort(((a, b) => b.data.compareTo(a.data)));
    return _t;
  }

  Future<List<_Fatture>> _getFatture() async {
    List<_Fatture> _f = [];
    var collection = FirebaseFirestore.instance
        .collection('Utenti')
        .doc(_codiceFiscale)
        .collection('fatture');
    var docSnapshot = await collection.get();
    if (docSnapshot.docs.isNotEmpty) {
      for (var i in docSnapshot.docs) {
        _f.add(
            _Fatture(i['emissione'], i['scadenza'], i['importo'], i['stato']));
      }
    }
    _f.sort(((a, b) => b.scadenza.compareTo(a.scadenza)));
    return _f;
  }

  Widget _sacchetti() {
    return FutureBuilder<List<_Transazioni>>(
      future: _getSacchietti(), // async work
      builder:
          (BuildContext context, AsyncSnapshot<List<_Transazioni>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text(
              'Loading....',
              style: TextStyle(color: Colors.white),
            );
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white));
            } else {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Operatore:'),
                                  Text(snapshot.data![index].addetto)
                                ]),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Codice:'),
                                    Text(snapshot.data![index].codice)
                                  ]),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Data e ora:'),
                                  Text(
                                      snapshot.data![index].data
                                              .toDate()
                                              .day
                                              .toString() +
                                          '/' +
                                          snapshot.data![index].data
                                              .toDate()
                                              .month
                                              .toString() +
                                          '/' +
                                          snapshot.data![index].data
                                              .toDate()
                                              .year
                                              .toString() +
                                          '   ' +
                                          snapshot.data![index].data
                                              .toDate()
                                              .hour
                                              .toString() +
                                          ':' +
                                          snapshot.data![index].data
                                              .toDate()
                                              .minute
                                              .toString())
                                ]),
                          ],
                        ));
                  },
                  separatorBuilder: (context, index) {
                    return const Padding(
                        padding: EdgeInsets.all(18),
                        child: Divider(
                          thickness: 1.5,
                        ));
                  },
                  itemCount: snapshot.data!.length);
            }
        }
      },
    );
  }

  Widget _fattur() {
    return FutureBuilder<List<_Fatture>>(
      future: _getFatture(), // async work
      builder: (BuildContext context, AsyncSnapshot<List<_Fatture>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text(
              'Loading....',
              style: TextStyle(color: Colors.white),
            );
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white));
            } else {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        color: snapshot.data![index].stato
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        snapshot.data![index].stato
                                            ? 'Pagata'
                                            : 'Da Pagare',
                                        style: TextStyle(
                                            color: snapshot.data![index].stato
                                                ? Colors.green
                                                : Colors.red),
                                      ))
                                ]),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Emissione:'),
                                    Text(snapshot.data![index].emissione
                                            .toDate()
                                            .day
                                            .toString() +
                                        '/' +
                                        snapshot.data![index].emissione
                                            .toDate()
                                            .month
                                            .toString() +
                                        '/' +
                                        snapshot.data![index].emissione
                                            .toDate()
                                            .year
                                            .toString())
                                  ]),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Scadeza:'),
                                      Text(snapshot.data![index].scadenza
                                              .toDate()
                                              .day
                                              .toString() +
                                          '/' +
                                          snapshot.data![index].scadenza
                                              .toDate()
                                              .month
                                              .toString() +
                                          '/' +
                                          snapshot.data![index].scadenza
                                              .toDate()
                                              .year
                                              .toString())
                                    ])),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Importo:'),
                                  Text(snapshot.data![index].importo + ' €')
                                ]),
                          ],
                        ));
                  },
                  separatorBuilder: (context, index) {
                    return const Padding(
                        padding: EdgeInsets.all(18),
                        child: Divider(
                          thickness: 1.5,
                        ));
                  },
                  itemCount: snapshot.data!.length);
            }
        }
      },
    );
  }
}

class _Transazioni {
  _Transazioni(this.richiedente, this.addetto, this.codice, this.data);

  final String richiedente;
  final String addetto;
  final String codice;
  final Timestamp data;
}

class _Fatture {
  _Fatture(this.emissione, this.scadenza, this.importo, this.stato);

  final Timestamp emissione;
  final Timestamp scadenza;
  final String importo;
  final bool stato;
}
