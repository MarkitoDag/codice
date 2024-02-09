import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:utente/calendario.dart';
import 'package:utente/info.dart';
import 'package:utente/messaggi.dart';
import 'package:utente/profilo.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late CollectionReference reference;
  int _index = 0;
  final _user = FirebaseAuth.instance.currentUser;
  bool _showBadge = false;
  String _codiceFiscale = '';
  bool _finito = false;

  Future<String> getUtente() async {
    var collection = FirebaseFirestore.instance.collection('Utenti');
    var docSnapshot = await collection.get();
    if (docSnapshot.docs.isNotEmpty) {
      for (var i in docSnapshot.docs) {
        if (i['email'] == FirebaseAuth.instance.currentUser!.email) {
          return i.id;
        }
      }
    }
    return 'Error';
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
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 35,
                  colors: [
                    Color(0xFF666666),
                    Color(0xFF87b837),
                  ],
                ),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: NavigationBar(
                  onDestinationSelected: (value) =>
                      setState(() => _index = value),
                  backgroundColor: Colors.transparent,
                  selectedIndex: _index,
                  height: 60,
                  destinations: [
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _index = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            _index == 0 ? Icons.home : Icons.home_outlined,
                            color: Colors.white,
                            size: _index == 0 ? 40 : 27,
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: _index == 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            _index = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              _index == 1 ? Icons.email : Icons.email_outlined,
                              color: Colors.white,
                              size: _index == 1 ? 40 : 27,
                            ),
                            Text(
                              'Messaggi',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: _index == 1
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: Colors.white),
                            )
                          ],
                        )),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _index = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            _index == 2 ? Icons.person : Icons.person_outline,
                            color: Colors.white,
                            size: _index == 2 ? 40 : 27,
                          ),
                          Text(
                            'Profilo',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: _index == 2
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _index = 3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            _index == 3
                                ? Icons.calendar_month
                                : Icons.calendar_month_outlined,
                            color: Colors.white,
                            size: _index == 3 ? 40 : 27,
                          ),
                          Text(
                            'Info',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: _index == 3
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: _index == 0
                ? const Info()
                : _index == 1
                    ? const Messaggi()
                    : _index == 2
                        ? const Profilo()
                        : Calendario(
                            codiceFiscale: _codiceFiscale,
                          ),
          );
  }
}
