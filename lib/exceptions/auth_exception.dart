class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "Email já cadastrado!",
    "OPERATION_NOT_ALLOWED": "Operação não permitida",
    "TOO_MANY_ATTEMPTS_TRY_LATER":
        "Acesso bloqueado temporariamente, tente novamente mais tarde!",
    "EMAIL_NOT_FOUND": "Email não encontrado!",
    "INVALID_PASSWORD": "Senha não confere!",
    "USER_DISABLED": "O usuário foi desabilitado!",
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? "Ocorreu um erro no processo de autenticação.";
  }
}
