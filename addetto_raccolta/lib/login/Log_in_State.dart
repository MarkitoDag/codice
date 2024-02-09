import 'package:addetto_raccolta/login/Form_submition.dart';

class LoginState {
  final String codiceFiscale;

  final String password;
  bool get isValidPassword => password.length >= 6;
  final Form_submissin_status formStatus;

  LoginState({
    this.codiceFiscale = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });
  LoginState copyWith(
      {String? codiceFiscale,
      String? password,
      Form_submissin_status? formStatus}) {
    return LoginState(
        codiceFiscale: codiceFiscale ?? this.codiceFiscale,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus);
  }
}
