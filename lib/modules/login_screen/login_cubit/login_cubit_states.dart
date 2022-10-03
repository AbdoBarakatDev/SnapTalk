abstract class LoginStates {}

class LoginInitialStates extends LoginStates {}

class LoginLoadingStates extends LoginStates {}

class LoginSuccessStates extends LoginStates {
  final String? id;

  LoginSuccessStates(this.id);
}

class LoginChangePasswordVisibilityStates extends LoginStates {}

class LoginErrorStates extends LoginStates {
  final String error;

  LoginErrorStates(this.error);
}

class LogOutSuccessStates extends LoginStates {}

class LogOutFailStates extends LoginStates {}

class LogOutLoadingStates extends LoginStates {}
