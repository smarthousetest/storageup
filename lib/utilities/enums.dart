enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  wrongPassword,
  emailAllreadyRegistered,
  externalError,
}

enum AuthError {
  wrongCredentials,
  emailAlreadyRegistered,
}
