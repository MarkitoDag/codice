import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:utente/main.dart';

class Profilo extends StatefulWidget {
  const Profilo({Key? key}) : super(key: key);

  @override
  State<Profilo> createState() => _ProfiloState();
}

class _ProfiloState extends State<Profilo> {
  bool _modifica = false;
  TextEditingController _controller = TextEditingController();
  final _user = FirebaseAuth.instance.currentUser;
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

  Future<DateTime> getData() async {
    var collection =
        FirebaseFirestore.instance.collection('Utenti').doc(await getUtente());
    var docSnapshot = await collection.get();
    if (docSnapshot.exists) {
      return docSnapshot['ultimoRitiro'].toDate();
    }
    return DateTime.now();
  }

  @override
  void initState() {
    getUtente().then((value) {
      setState(() {
        _codiceFiscale = value;
        _finito = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_finito
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Profilo ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Utenti')
                            .doc(_codiceFiscale)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.exists) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Nome:'),
                                    Text(snapshot.data!['nome']),
                                  ],
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(18),
                                    child: Divider(
                                      thickness: 0.5,
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Cognome:'),
                                    Text(snapshot.data!['cognome']),
                                  ],
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(18),
                                    child: Divider(
                                      thickness: 0.5,
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('comune:'),
                                    Text(snapshot.data!['comune']),
                                  ],
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(18),
                                    child: Divider(
                                      thickness: 0.5,
                                    )),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  child: Row(
                                    children: [
                                      const Text('indirizzo:'),
                                      const Spacer(),
                                      _modifica
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 15),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                height: 60,
                                                child: TextField(
                                                  autocorrect: false,
                                                  controller: _controller,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                ),
                                              ))
                                          : Text(snapshot.data!['indirizzo']),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            if (!_modifica) {
                                              setState(() {
                                                _modifica = true;
                                                _controller.text =
                                                    snapshot.data!['indirizzo'];
                                              });
                                            } else {
                                              FirebaseFirestore _firestore =
                                                  FirebaseFirestore.instance;
                                              DocumentReference docRef =
                                                  _firestore
                                                      .collection('Utenti')
                                                      .doc(_codiceFiscale);
                                              WriteBatch write =
                                                  _firestore.batch();
                                              write.update(docRef, {
                                                'indirizzo':
                                                    _controller.text.trim()
                                              });

                                              await write.commit();

                                              setState(() {
                                                _modifica = false;
                                              });
                                            }
                                          },
                                          child: Icon(_modifica
                                              ? Icons.save
                                              : Icons.edit))
                                    ],
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(18),
                                    child: Divider(
                                      thickness: 0.5,
                                    )),
                              ]),
                            );
                          }
                          return const Center(
                            child: Text(
                              "No data",
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(index == 0 ? 'Email:' : 'Password:'),
                                Text(index == 0
                                    ? FirebaseAuth.instance.currentUser!.email!
                                    : '°°°°°°°°')
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                            padding: EdgeInsets.all(18),
                            child: Divider(
                              thickness: 0.5,
                            ));
                      },
                      itemCount: 2),
                ),
                InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: const MainPage()));
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
                              Icon(Icons.logout_outlined),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Esci'),
                            ])),
                  ),
                ),
              ],
            ),
          ));
  }
}
