import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistema_gestione_comune/login/Auth_cubit.dart';
import 'package:sistema_gestione_comune/login/Log_in.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return Navigator(
        pages: [
          if (state == AuthState.login) const MaterialPage(child: Log_in())
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
