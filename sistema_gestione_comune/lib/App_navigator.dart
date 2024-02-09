import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistema_gestione_comune/Loading_view.dart';
import 'package:sistema_gestione_comune/Session_cubit.dart';
import 'package:sistema_gestione_comune/Session_state.dart';
import 'package:sistema_gestione_comune/Session_view.dart';
import 'package:sistema_gestione_comune/login/Auth_cubit.dart';
import 'package:sistema_gestione_comune/login/Auth_navigator.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
        pages: [
          if (state is UnknownSessionState)
            const MaterialPage(child: LoadingView()),
          if (state is Unauthenticated)
            MaterialPage(
                child: BlocProvider(
                    create: (context) =>
                        AuthCubit(sessionCubit: context.read<SessionCubit>()),
                    child: const AuthNavigator())),
          if (state is Authenticated)
            MaterialPage(
                child: SessionView(
              codiceFiscale: state.user,
            ))
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
