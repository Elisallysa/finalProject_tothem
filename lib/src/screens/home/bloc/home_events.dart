abstract class HomeEvent {
// Abstract class containing Log in and Sign up events.
  const HomeEvent();
}

class UserInfoEvent extends HomeEvent {
// MailEvent event class gets a String with the Email address value.
  final String userName;
  const UserInfoEvent(this.userName);
}
