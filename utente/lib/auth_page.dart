import 'package:flutter/material.dart';
import 'package:utente/log_in_view.dart';
import 'package:utente/sign_up_view.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? LogInView(onClickedSignUp: toggle)
      : SignUpView(onClickedSigIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
