class LogInWithEmailAndPasswordFailure {
  final String message;

  const LogInWithEmailAndPasswordFailure([this.message = "An Unknown error Occurred."]);

  factory LogInWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure("No user found for that email.");
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure("Incorrect password provided for that user.");
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure("The email address is badly formatted or invalid.");
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure("This user has been disabled.");
      case 'operation-not-allowed':
        return const LogInWithEmailAndPasswordFailure("This operation is not allowed.");
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

}
