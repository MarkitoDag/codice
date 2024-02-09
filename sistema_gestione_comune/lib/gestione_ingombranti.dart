import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sistema_gestione_comune/bottom_sheet.dart';

class GestioneIngombrantiView extends StatefulWidget {
  const GestioneIngombrantiView({Key? key}) : super(key: key);

  @override
  State<GestioneIngombrantiView> createState() =>
      _GestioneIngombrantiViewState();
}

class _GestioneIngombrantiViewState extends State<GestioneIngombrantiView>
    with TickerProviderStateMixin {
  int _key = 0;
  late AnimationController controller;
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

  @override
  Widget build(BuildContext context) {
    //_dataAggiunta = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestione ingombranti'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (_) => bs(k: _k),
        ),
        child: const Icon(Icons.add),
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
                                              child:
                                                  Text('  Stato prenotazioni')),
                                          const SizedBox(
                                            height: 18,
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: LinearPercentIndicator(
                                                lineHeight: 5,
                                                percent: snap
                                                        .data!.docs.isNotEmpty
                                                    ? (snap.data!.docs.length -
                                                            1) /
                                                        doc['numero']
                                                    : (snap.data!.docs.length) /
                                                        doc['numero'],
                                                progressColor: (snap.data!.docs
                                                                .isNotEmpty
                                                            ? (snap.data!.docs
                                                                        .length -
                                                                    1) /
                                                                doc['numero']
                                                            : (snap.data!.docs
                                                                    .length) /
                                                                doc['numero']) >
                                                        0.75
                                                    ? Colors.red
                                                    : (snap.data!.docs
                                                                    .isNotEmpty
                                                                ? (snap.data!.docs
                                                                            .length -
                                                                        1) /
                                                                    doc[
                                                                        'numero']
                                                                : (snap
                                                                        .data!
                                                                        .docs
                                                                        .length) /
                                                                    doc['numero']) >
                                                            0.55
                                                        ? Colors.yellow
                                                        : Colors.green,
                                              ))
                                        ]));
                                  } else {
                                    return const Center(
                                        child: Text(
                                            "informazione momentaneaente non disponibile",
                                            style: TextStyle(
                                                color: Colors.black)));
                                  }
                                },
                              ),
                            ],
                          ));
                    });
          } else {
            return const Center(
                child: Text("No dat", style: TextStyle(color: Colors.black)));
          }
        },
      ),
    );
  }

  void _k(int i) {
    setState(() {
      _key = _key + 1;
    });
  }
}
