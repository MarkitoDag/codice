abstract class Loginevent {}

class LoginCodiceFiscaleChanged extends Loginevent {
  final String codiceFiscale;

  LoginCodiceFiscaleChanged({required this.codiceFiscale});
}

class PasswordChanged extends Loginevent {
  final String password;

  PasswordChanged({required this.password});
}

class LoginSubmitted extends Loginevent {}
