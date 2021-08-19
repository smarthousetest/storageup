import 'package:formz/formz.dart';

enum NameValidationError { empty }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {
    bool isValuesLengthNotTooSmall;
    bool isValuesLengthNotTooBig;
    if (value != null) {
      isValuesLengthNotTooSmall = value.length > 2;
      isValuesLengthNotTooBig = value.length < 100;

      return isValuesLengthNotTooSmall && isValuesLengthNotTooBig
          ? null
          : NameValidationError.empty;
    }
    return value?.isNotEmpty == true ? null : NameValidationError.empty;
  }
}
