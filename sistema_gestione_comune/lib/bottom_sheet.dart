import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class bs extends StatefulWidget {
  final ValueChanged<int> k;
  const bs({
    Key? key,
    required this.k,
  }) : super(key: key);

  @override
  State<bs> createState() => _bsState();
}

Future<bool> check(String string) async {
  var collection = FirebaseFirestore.instance.collection('ritiroIngombranti');
  var docSnapshot = await collection.get();

  if (docSnapshot.docs.isNotEmpty) {
    for (var i in docSnapshot.docs) {
      if (i.id == string) {
        return true;
      }
    }
    return false;
  } else {
    return false;
  }
}

class _bsState extends State<bs> {
  aggiungi() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.runTransaction((transaction) async {
      DocumentReference puntiRef = _firestore
          .collection('ritiroIngombranti')
          .doc(_dataAggiunta.day.toString() +
              '-' +
              _dataAggiunta.month.toString() +
              '-' +
              _dataAggiunta.year.toString());
      DocumentSnapshot snap = await transaction.get(puntiRef);

      transaction.set(puntiRef, {'numero': _numeroRitiri});
    });
    FirebaseFirestore _firestore1 = FirebaseFirestore.instance;
    await _firestore1.runTransaction((transaction) async {
      DocumentReference puntiRef1 = _firestore1
          .collection('ritiroIngombranti')
          .doc(_dataAggiunta.day.toString() +
              '-' +
              _dataAggiunta.month.toString() +
              '-' +
              _dataAggiunta.year.toString())
          .collection('tickets')
          .doc('0');
      DocumentSnapshot snap1 = await transaction.get(puntiRef1);

      transaction.set(puntiRef1, {'0': ''});
    });
  }

  DateTime _dataAggiunta = DateTime.now();
  bool _cambiato = false;
  bool _confermato = false;
  int _numeroRitiri = 3;
  bool _abilita = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime(DateTime.now().year, 12, 31),
              theme: const DatePickerTheme(
                  headerColor: Colors.blue,
                  backgroundColor: Colors.white,
                  itemStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  doneStyle: TextStyle(color: Colors.black, fontSize: 16)),
              onChanged: (date) {
            setState(() {
              _cambiato = true;
            });
          }, onConfirm: (date) async {
            setState(() {
              _dataAggiunta = date;
              _confermato = true;
            });
          }, currentTime: DateTime.now(), locale: LocaleType.it),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              height: 45,
              child: const Center(
                child: Text(
                  'Seleziona la data',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: _cambiato && _confermato
              ? Text(
                  'Data:    ' +
                      _dataAggiunta.day.toString() +
                      '-' +
                      _dataAggiunta.month.toString() +
                      '-' +
                      _dataAggiunta.year.toString(),
                  style: TextStyle(fontSize: 18),
                  key: ValueKey(_dataAggiunta),
                )
              : const Text(''),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: _cambiato && _confermato
              ? FutureBuilder<bool>(
                  future: check(_dataAggiunta.day.toString() +
                      '-' +
                      _dataAggiunta.month.toString() +
                      '-' +
                      _dataAggiunta.year.toString()), // async work
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
                          return Text(
                            snapshot.data! ? 'Data già presente' : '',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.red),
                          );
                        }
                    }
                  },
                )
              : const Text(''),
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Numero ritiri:',
          style: TextStyle(fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(() => _numeroRitiri > 1
                    ? _numeroRitiri = _numeroRitiri - 1
                    : null),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  child: const Center(
                    child: Text(
                      '-',
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  _numeroRitiri.toString(),
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              InkWell(
                onTap: () => setState(() => _numeroRitiri < 15
                    ? _numeroRitiri = _numeroRitiri + 1
                    : null),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  child: const Center(
                    child: Text(
                      '+',
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: _cambiato && _confermato
              ? FutureBuilder<bool>(
                  future: check(_dataAggiunta.day.toString() +
                      '-' +
                      _dataAggiunta.month.toString() +
                      '-' +
                      _dataAggiunta.year.toString()), // async work
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
                          return InkWell(
                              onTap: () {
                                snapshot.data! ? null : aggiungi();
                                widget.k(1);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: snapshot.data!
                                        ? Colors.grey
                                        : Colors.green),
                                child: const Center(
                                    child: Text(
                                  'Conferma',
                                  style: TextStyle(color: Colors.white),
                                )),
                              ));
                        }
                    }
                  },
                )
              : Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  child: const Center(
                      child: Text('Conferma',
                          style: TextStyle(color: Colors.white))),
                ),
        )
      ],
    );
  }
}
