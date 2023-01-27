abstract class SocialLoginStates {}

class SocialLoginInitialState extends SocialLoginStates {}

class SocialLoginLoadingState extends SocialLoginStates {}

class SocialLoginSucessState extends SocialLoginStates {}

class SocialLoginErrorState extends SocialLoginStates {
  final String error;

  SocialLoginErrorState(this.error);
}

class SocialLoginchangePasswordVisibilityState extends SocialLoginStates {}

class SocialLogoutSucessState extends SocialLoginStates {}

class SocialLogoutErrorState extends SocialLoginStates {}
