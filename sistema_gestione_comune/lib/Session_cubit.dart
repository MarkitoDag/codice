import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistema_gestione_comune/Session_state.dart';
import 'package:sistema_gestione_comune/login/AuthRepository.dart';
import 'package:sistema_gestione_comune/login/Auth_credential.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  SessionCubit({required this.authRepo}) : super(UnknownSessionState()) {
    attemptLogIn();
  }

  void showAuth() => emit(Unauthenticated());
  void showSession(AuthCredential credential) {
    final user = credential.codiceFiscale;
    emit(Authenticated(user: user));
  }

  void attemptLogIn() async {
    try {
      final user = await authRepo.attemptToLogIn();
      emit(Authenticated(user: user));
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  void signOut() {
    authRepo.signout();
    emit(Unauthenticated());
  }
}
