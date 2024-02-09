import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailView extends StatelessWidget {
  final String cartella;
  final String codiceFiscale;
  const DetailView(
      {Key? key, required this.cartella, required this.codiceFiscale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli'),
        backgroundColor: const Color(0xFF666666),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'Raccolta ' +
                    (cartella == 'carta'
                        ? 'carta e cartone'
                        : cartella == 'secco'
                            ? 'rifiuti non riciclabili'
                            : cartella == 'umido'
                                ? 'rifiuti organici'
                                : cartella == 'vetro'
                                    ? 'vetro'
                                    : 'plastica e lattine'),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Utenti')
                    .doc(codiceFiscale)
                    .collection(cartella)
                    .orderBy('data', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.docs.isEmpty
                        ? const Center(
                            child: Text(
                              "No data",
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];

                              return Column(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Data:'),
                                      Text(doc['data'].toDate().day.toString() +
                                          '-' +
                                          doc['data']
                                              .toDate()
                                              .month
                                              .toString() +
                                          '-' +
                                          doc['data'].toDate().year.toString())
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Peso:'),
                                      Text(doc['peso'] + ' Kg'),
                                    ],
                                  ),
                                ),
                                Text(
                                  doc['segnalata']
                                      ? 'Il conferimento è stato segnalato come non conforme'
                                      : 'Conferimento avvenuto con successo',
                                  style: TextStyle(
                                      color: doc['segnalata']
                                          ? Colors.red
                                          : Colors.green),
                                )
                              ]);
                            },
                            separatorBuilder: (context, index) {
                              return const Padding(
                                  padding: EdgeInsets.all(18),
                                  child: Divider(
                                    thickness: 1.5,
                                  ));
                            },
                            itemCount: snapshot.data!.docs.length);
                  } else {
                    return const Center(
                        child: Text(
                      "No data",
                      style: TextStyle(color: Colors.black),
                    ));
                  }
                }),
          ),
        ],
      ),
    );
  }
}
