import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class CodiceView extends StatelessWidget {
  final String codiceFiscale;
  const CodiceView({Key? key, required this.codiceFiscale}) : super(key: key);
  Future _rendiPersistente() async {
    FirebaseFirestore _firestore8 = FirebaseFirestore.instance;
    var docRef8 = _firestore8
        .collection('Utenti')
        .doc(codiceFiscale)
        .collection('codice_ritiro')
        .doc('codice');
    docRef8.update({
      'data': DateTime.now(),
      'persistente': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF666666),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Center(child: Text('Codice per il ritiro:')),
        StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Utenti')
                .doc(codiceFiscale)
                .collection('codice_ritiro')
                .doc('codice')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                return Column(children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Text(
                    !snapshot.data!['persistente']
                        ? 'Non chiudere l\'app finché la consegna non sarà avvenuta'
                        : '',
                    style: const TextStyle(color: Colors.red),
                  )),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 300,
                    child: SfBarcodeGenerator(
                      barColor: Colors.black,
                      value: snapshot.data!['codice'],
                      symbology: Code128C(),
                      showValue: true,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  !snapshot.data!['persistente']
                      ? InkWell(
                          onTap: () async {
                            _rendiPersistente();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Container(
                                decoration: BoxDecoration(
                                  gradient: const RadialGradient(
                                    center: Alignment.topRight,
                                    radius: 15,
                                    colors: [
                                      Colors.red,
                                      Color(0xFF666666),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.lock),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text('Rendi codice persistente'),
                                    ])),
                          ),
                        )
                      : Center(
                          child: Text(
                              'Codice persistente con scadenza:\n       ' +
                                  snapshot.data!['data']
                                      .toDate()
                                      .add(const Duration(days: 1))
                                      .toString()),
                        )
                ]);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
        const SizedBox(
          height: 50,
        ),
      ]),
    );
  }
}
