import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:utente/forgot_password_view.dart';
import 'package:utente/main.dart';
import 'package:utente/utils.dart';

class LogInView extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LogInView({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                TextField(
                  autocorrect: false,
                  controller: _emailController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextField(
                  autocorrect: false,
                  obscureText: true,
                  controller: _passwordController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    signIn();
                  },
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Accedi'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                GestureDetector(
                  child: const Text(
                    'Password dimenticata?',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontSize: 16),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordView(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      text: 'Non hai un account?    ',
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignUp,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                          text: 'Registrati',
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      );

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contex) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message, Colors.red);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
