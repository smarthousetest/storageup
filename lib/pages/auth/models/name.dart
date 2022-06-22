import 'package:formz/formz.dart';

enum NameValidationError { empty }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure()
      : this.needValidation = true,
        super.pure('');
  const Name.dirty([String value = '', bool needValidation = true])
      : this.needValidation = needValidation,
        super.dirty(value);

  final bool needValidation;

  @override
  NameValidationError? validator(String? value) {
    if (needValidation) {
      bool isValuesLengthNotTooSmall;
      bool isValuesLengthNotTooBig;
      if (value != null) {
        isValuesLengthNotTooSmall = value.replaceAll(' ', '').length > 2;
        isValuesLengthNotTooBig = value.replaceAll(' ', '').length < 100;

        return isValuesLengthNotTooSmall && isValuesLengthNotTooBig ? null : NameValidationError.empty;
      }
      return value?.isNotEmpty == true ? null : NameValidationError.empty;
    }

    return null;
  }
}
