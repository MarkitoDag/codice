import 'package:addetto_raccolta/Loading_view.dart';
import 'package:addetto_raccolta/Session_cubit.dart';
import 'package:addetto_raccolta/Session_state.dart';
import 'package:addetto_raccolta/Session_view.dart';
import 'package:addetto_raccolta/login/Auth_cubit.dart';
import 'package:addetto_raccolta/login/Auth_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
