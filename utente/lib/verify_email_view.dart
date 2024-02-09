import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utente/splash_screen.dart';
import 'package:utente/utils.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool _isEmailVerified = false;
  bool _canResendEmail = false;
  Timer? timer;
  @override
  void initState() {
    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!_isEmailVerified) {
      !_canResendEmail ? sendVerificationEmail() : null;
      timer = Timer.periodic(
          const Duration(seconds: 6), (_) => checkEmailVerified());
    }
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (_isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final _user = FirebaseAuth.instance.currentUser!;
      await _user.sendEmailVerification();

      setState(() => _canResendEmail = true);
      await Future.delayed(const Duration(minutes: 1), () {
        setState(() => _canResendEmail = false);
      });
    } catch (e) {
      Utils.showSnackBar(e.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) => _isEmailVerified
      ? const SplashScreen()
      : SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Verifica email'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'E\' stata mandata un email di verifica.  Controlla la tua casella postale e segui il link fornito per verificare il tuo account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () =>
                        !_canResendEmail ? sendVerificationEmail() : null,
                    icon: const Icon(Icons.email_outlined),
                    label: const Text(
                      'Invia di nuovo',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text(
                      'Annulla',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
}
