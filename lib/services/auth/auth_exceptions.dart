// login exceptions
class InvalidCredentialsException implements Exception {}

// register
class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class InvalidEmailException implements Exception {}

// generic
class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}
