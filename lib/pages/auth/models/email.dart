import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure()
      : this.needValidation = true,
        super.pure('');
  const Email.dirty([String value = '', bool needValidation = true])
      : this.needValidation = needValidation,
        super.dirty(value);

  static final _emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  final bool needValidation;

  @override
  EmailValidationError? validator(String? value) {
    if (needValidation)
      return _emailRegex.hasMatch(value ?? '')
          ? null
          : EmailValidationError.invalid;

    return null;
  }
}
