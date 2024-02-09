import 'package:addetto_raccolta/login/AuthRepository.dart';
import 'package:addetto_raccolta/login/Auth_cubit.dart';
import 'package:addetto_raccolta/login/Log_in_BLoc.dart';
import 'package:addetto_raccolta/login/Log_in_State.dart';
import 'package:addetto_raccolta/login/Log_in_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Form_submition.dart';

class Log_in extends StatefulWidget {
  const Log_in({Key? key}) : super(key: key);

  @override
  State<Log_in> createState() => _Log_inState();
}

class _Log_inState extends State<Log_in> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Gestione raccolta'),
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(
          authRepo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: _logInForm(),
      ),
    );
  }

  Widget _logInForm() {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final formStatus = state.formStatus;

          if (formStatus is SubmissionFailed) {
            _showSnakBar(context, formStatus.exception.toString());
          }
        },
        child: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          'Log in',
                          style: TextStyle(fontSize: 35),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: _codiceFiscaleField(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: _passwordField(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: _logInButton(),
                    ),
                    const Spacer()
                  ],
                ))));
  }

  Widget _codiceFiscaleField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
          obscureText: false,
          decoration: const InputDecoration(
              icon: Icon(Icons.person), hintText: 'Codice operatore'),
          onChanged: (value) => context
              .read<LoginBloc>()
              .add(LoginCodiceFiscaleChanged(codiceFiscale: value)));
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
            icon: Icon(Icons.security), hintText: 'Password'),
        validator: (value) =>
            state.isValidPassword ? null : 'Password troppo corta.',
        onChanged: (value) =>
            context.read<LoginBloc>().add(PasswordChanged(password: value)),
      );
    });
  }

  Widget _logInButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is FormsSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              },
              child: const Text('Accedi'));
    });
  }

  void _showSnakBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
