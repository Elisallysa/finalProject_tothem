/// [WelcomeState] transmits the events happening in Log-in and Sign-up to BLoC
/// in order to perform the corresponding logic.
class WelcomeState {
  final String mail;
  final String password;
  final String repeatPassword;

  /// [WelcomeState] unnamed constructor. [mail], [password] and [repeatPassword]
  /// are optional named parameters. This way the constructor can be called without
  /// explicitly setting the parameters' values.
  const WelcomeState(
      {this.mail = "", this.password = "", this.repeatPassword = ""});

  /// Allows the creation of an user object with or without the attributes declared
  /// in [WelcomeState]. This copies the parameters of a previous object if any.
  WelcomeState copyWith(
      {String? mail, String? password, String? repeatPassword}) {
    return WelcomeState(
        mail: mail ?? this.mail,
        password: password ?? this.password,
        repeatPassword: repeatPassword ?? this.repeatPassword);
  }
}
