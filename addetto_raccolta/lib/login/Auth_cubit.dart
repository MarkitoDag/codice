import 'package:addetto_raccolta/Session_cubit.dart';
import 'package:addetto_raccolta/login/Auth_credential.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState { login }

class AuthCubit extends Cubit<AuthState> {
  final SessionCubit sessionCubit;
  AuthCubit({required this.sessionCubit}) : super(AuthState.login);

  void showLogin() => emit(AuthState.login);
  void launchSession(AuthCredential authCredential) =>
      sessionCubit.showSession(authCredential);
}
