class WelcomeEvents {}

abstract class WelcomeEvent {
  const WelcomeEvent();
}

class MailEvent extends WelcomeEvent {
  final String mail;
  const MailEvent(this.mail);
}

class PwdEvent extends WelcomeEvent {
  final String password;
  const PwdEvent(this.password);
}
