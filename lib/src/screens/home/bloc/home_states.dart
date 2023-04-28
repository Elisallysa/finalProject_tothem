/// [HomeState] transmits the events to BLoC in order to perform the corresponding logic.
class HomeState {
  final String userName;
  final String userLastname;
  final String userRole;

  /// [HomeState] unnamed constructor. [userName], [userLastname] and [userRole]
  /// are optional named parameters. This way the constructor can be called without
  /// explicitly setting the parameters' values.
  const HomeState(
      {this.userName = "", this.userLastname = "", this.userRole = ""});

  /// Allows the creation of an user object with or without the attributes declared
  /// in [HomeState]. This copies the parameters of a previous object if any.
  HomeState copyWith(
      {String? userName, String? userLastname, String? userRole}) {
    return HomeState(
        userName: userName ?? this.userName,
        userLastname: userLastname ?? this.userLastname,
        userRole: userRole ?? this.userRole);
  }
}
