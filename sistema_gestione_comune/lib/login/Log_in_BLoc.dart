import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistema_gestione_comune/login/AuthRepository.dart';
import 'package:sistema_gestione_comune/login/Auth_credential.dart';
import 'package:sistema_gestione_comune/login/Auth_cubit.dart';
import 'package:sistema_gestione_comune/login/Form_submition.dart';
import 'package:sistema_gestione_comune/login/Log_in_State.dart';
import 'package:sistema_gestione_comune/login/Log_in_event.dart';

class LoginBloc extends Bloc<Loginevent, LoginState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;
  LoginBloc({required this.authRepo, required this.authCubit})
      : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(Loginevent event) async* {
    if (event is LoginCodiceFiscaleChanged) {
      yield state.copyWith(codiceFiscale: event.codiceFiscale);
    } else if (event is PasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormsSubmitting());
      try {
        await authRepo.login(
            codiceFiscale: state.codiceFiscale, password: state.password);
        yield state.copyWith(formStatus: SubmissionSucces());
        authCubit.launchSession(AuthCredential(
            codiceFiscale: state.codiceFiscale, password: state.password));
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}
