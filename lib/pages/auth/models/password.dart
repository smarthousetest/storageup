import 'package:formz/formz.dart';

enum PasswordValidationError { empty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure()
      : this.needValidation = true,
        super.pure('');
  const Password.dirty([String value = '', bool needValidation = true])
      : this.needValidation = needValidation,
        super.dirty(value);

  final bool needValidation;

  @override
  PasswordValidationError? validator(String value) {
    if (needValidation)
      return value.length > 7 ? null : PasswordValidationError.empty;

    return null;
  }
}
