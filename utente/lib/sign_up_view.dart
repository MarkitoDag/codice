import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:utente/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:utente/utils.dart';

class SignUpView extends StatefulWidget {
  final Function() onClickedSigIn;
  const SignUpView({Key? key, required this.onClickedSigIn}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confermaPasswordController = TextEditingController();
  final _CodiceFiscaleController = TextEditingController();
  final _comuneController = TextEditingController();
  final _indirizzoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _cognomeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _emailController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Inserisci un email valida'
                            : null,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    controller: _passwordController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Password'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) =>
                        password != null && password.length < 6
                            ? 'Password troppo corta'
                            : null,
                  ),
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    controller: _confermaPasswordController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(labelText: 'Conferma password'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) => password != null &&
                            _passwordController.text.trim() != password
                        ? 'Le password non corrispondono'
                        : null,
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _CodiceFiscaleController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(labelText: 'Codice Fiscale'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (cf) => cf != null && cf.length != 16
                        ? 'Coodice Fiscale non valido.'
                        : null,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _nomeController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _cognomeController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Cognome'),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _comuneController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Comune'),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _indirizzoController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Indirizzo'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () async {
                      if (_emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty &&
                          _confermaPasswordController.text.isNotEmpty &&
                          _CodiceFiscaleController.text.isNotEmpty &&
                          _nomeController.text.isNotEmpty &&
                          _cognomeController.text.isNotEmpty &&
                          _comuneController.text.isNotEmpty &&
                          _indirizzoController.text.isNotEmpty) {
                        if (await controllaCodiceFiscale(
                            _CodiceFiscaleController.text.trim())) {
                          Utils.showSnackBar(
                              'Codice Fiscale già in uso', Colors.red);
                          return;
                        }
                        sigUp();
                      }
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Registrati'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                        text: 'Hai già un account?    ',
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSigIn,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                decoration: TextDecoration.underline),
                            text: 'Accedi',
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future sigUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message, Colors.red);
    }

    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference docRef = _firestore
        .collection('Utenti')
        .doc(_CodiceFiscaleController.text.trim().toUpperCase());
    WriteBatch write = _firestore.batch();
    write.set(docRef, {
      'nome': _nomeController.text.trim(),
      'cognome': _cognomeController.text.trim(),
      'email': _emailController.text.trim(),
      'indirizzo': _indirizzoController.text.trim(),
      'comune': _comuneController.text.trim(),
      'sacchetti': [],
      'ultimoRitiro': DateTime.now().subtract(const Duration(days: 7))
    });
    await write.commit();

    /*################################################################################################################################################################################################################################################################################################## */
    FirebaseFirestore _firestore1 = FirebaseFirestore.instance;
    var docRef1 = _firestore1
        .collection('Utenti')
        .doc(_CodiceFiscaleController.text.trim().toUpperCase())
        .collection('carta');
    docRef1.add({'data': DateTime.now(), 'peso': '0.9', 'segnalata': false});
    docRef1.add({
      'data': DateTime.now().subtract(const Duration(days: 2)),
      'peso': '1.1',
      'segnalata': false
    });
    docRef1.add({
      'data': DateTime.now().subtract(const Duration(days: 7)),
      'peso': '0.5',
      'segnalata': false
    });
    FirebaseFirestore _firestore2 = FirebaseFirestore.instance;
    var docRef2 = _firestore2
        .collection('Utenti')
        .doc(_CodiceFiscaleController.text.trim().toUpperCase())
        .collection('plastica');
    docRef2.add({'data': DateTime.now(), 'peso': '0.7', 'segnalata': false});
    docRef2.add({
      'data': DateTime.now().subtract(const Duration(days: 4)),
      'peso': '1.1',
      'segnalata': false
    });
    docRef2.add({
      'data': DateTime.now().subtract(const Duration(days: 5)),
      'peso': '0.6',
      'segnalata': true
    });

    FirebaseFirestore _firestore3 = FirebaseFirestore.instance;
    var docRef3 = _firestore3
        .collection('Utenti')
        .doc(_CodiceFiscaleController.text.trim().toUpperCase())
        .collection('vetro');
    docRef3.add({'data': DateTime.now(), 'peso': '2', 'segnalata': false});
    docRef3.add({
      'data': DateTime.now().subtract(const Duration(days: 1)),
      'peso': '1.5',
      'segnalata': false
    });
    docRef3.add({
      'data': DateTime.now().subtract(const Duration(days: 8)),
      'peso': '0.5',
      'segnalata': false
    });
    FirebaseFirestore _firestore4 = FirebaseFirestore.instance;
    var docRef4 = _firestore4
        .collection('Utenti')
        .doc(_CodiceFiscaleController.text.trim().toUpperCase())
        .collection('umido');
    docRef4.add({'data': DateTime.now(), 'peso': '1.8', 'segnalata': false});
    docRef4.add({
      'data': DateTime.now().subtract(const Duration(days: 7)),
      'peso': '1.4',
      'segnalata': false
    });
    docRef4.add({
      'data': DateTime.now().subtract(const Duration(days: 10)),
      'peso': '2.1',
      'segnalata': false
    });

    FirebaseFirestore _firestore5 = FirebaseFirestore.instance;
    var docRef5 = _firestore5
        .collection('Utenti')
        .doc(_CodiceFiscaleController.text.trim().toUpperCase())
        .collection('secco');
    docRef5.add({'data': DateTime.now(), 'peso': '0.8', 'segnalata': false});
    docRef5.add({
      'data': DateTime.now().subtract(const Duration(days: 1)),
      'peso': '0.7',
      'segnalata': false
    });
    docRef5.add({
      'data': DateTime.now().subtract(const Duration(days: 11)),
      'peso': '0.5',
      'segnalata': false
    });
    FirebaseFirestore _firestore6 = FirebaseFirestore.instance;
    var docRef6 = _firestore6
        .collection('Utenti')
        .doc(_CodiceFiscaleController.text.trim().toUpperCase())
        .collection('messaggi');
    docRef6.add({
      'data': DateTime.now(),
      'body':
          'Hai ricevuto una segnalazione sul conferimento di plastica del ' +
              DateTime.now().subtract(const Duration(days: 5)).toString(),
    });

    FirebaseFirestore _firestore7 = FirebaseFirestore.instance;
    var docRef7 = _firestore7
        .collection('Utenti')
        .doc(_CodiceFiscaleController.text.trim().toUpperCase())
        .collection('fatture');
    docRef7.add({
      'emissione': DateTime(2019, 1, 7),
      'importo': '401.35',
      'scadenza': DateTime(2019, 1, 31),
      'stato': true
    });
    docRef7.add({
      'emissione': DateTime(2020, 1, 9),
      'importo': '461.90',
      'scadenza': DateTime(2020, 1, 31),
      'stato': true
    });
    docRef7.add({
      'emissione': DateTime(2021, 1, 4),
      'importo': '398.10',
      'scadenza': DateTime(2021, 1, 31),
      'stato': false
    });

    FirebaseFirestore _firestore8 = FirebaseFirestore.instance;
    var docRef8 = _firestore8
        .collection('Utenti')
        .doc(_CodiceFiscaleController.text.trim().toUpperCase())
        .collection('codice_ritiro')
        .doc('codice');
    docRef8.set({
      'codice': '',
      'data': DateTime.now().subtract(const Duration(days: 7)),
      'persistente': false,
    });

    /*################################################################################################################################################################################################################################################################################################## */

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<bool> controllaCodiceFiscale(String verifica) async {
    final db = FirebaseFirestore.instance;
    var result = await db.collection('Utenti').get();

    for (var val in result.docs) {
      if (val.id.toUpperCase() == verifica.toUpperCase()) {
        return true;
      }
    }

    return false;
  }
}
