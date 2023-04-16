class WelcomeState {
  int page;
  final String mail;
  final String password;

  WelcomeState({this.page = 0, this.mail = "", this.password = ""});

  WelcomeState copyWith({String? mail, String? password}) {
    return WelcomeState(
        mail: mail ?? this.mail, password: password ?? this.password);
  }
}
