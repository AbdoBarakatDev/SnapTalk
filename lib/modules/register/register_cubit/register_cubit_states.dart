abstract class RegisterStates {}

class RegisterInitialStates extends RegisterStates {}

class RegisterLoadingStates extends RegisterStates {}

class RegisterSuccessStates extends RegisterStates {}

class UserCreationSuccessStates extends RegisterStates {}
class UserCreationErrorStates extends RegisterStates {
  final String error;

  UserCreationErrorStates(this.error);
}

class RegisterChangePasswordVisibilityStates extends RegisterStates {}
class ChangePhoneLengthStates extends RegisterStates {}

class RegisterErrorStates extends RegisterStates {
  final String error;

  RegisterErrorStates(this.error);
}
