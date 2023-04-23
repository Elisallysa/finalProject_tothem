abstract class WelcomeEvent {
// Abstract class containing Log in and Sign up events.
  const WelcomeEvent();
}

class MailEvent extends WelcomeEvent {
// MailEvent event class gets a String with the Email address value.
  final String mail;
  const MailEvent(this.mail);
}

class PwdEvent extends WelcomeEvent {
// PwdEvent event class gets a String with the password value.
  final String password;
  const PwdEvent(this.password);
}

class RePwdEvent extends WelcomeEvent {
  // RePwdEvent class gets a String with the repeat password value.
  final String repeatPassword;
  const RePwdEvent(this.repeatPassword);
}
