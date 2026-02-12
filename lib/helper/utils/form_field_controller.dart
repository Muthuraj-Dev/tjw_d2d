
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'input_formatter.dart';
import 'input_validator.dart';


//  Phone Form Field Controller
//  This controller used for only Phone Number Field
//
//  [Param]
//  * key - resourceId
//
//  [Optional Param]
//  * maxLength - length of the phone number, default will be 10
//  * required - default will be true
//
class PhoneFormFieldController extends FormFieldController {

  PhoneFormFieldController(super.fieldKey, { super.maxLength = 10, super.required = true });

  @override
  List<TextInputFormatter> get inputFormatter => InputFormatter.phoneNoFormatter;

  @override
  String? Function(String? p1)? get validator => !this.required ? null : InputValidator.phoneValidator;

  @override
  TextInputType get textInputType => TextInputType.phone;


}

//  Email Address Form Field Controller
//  This controller used for only Email Address Field
//
//  [Param]
//  * key - resourceId
//
//  [Optional Param]
//  * required - default will be true
//
class EmailFormFieldController extends FormFieldController {

  EmailFormFieldController(super.fieldKey,  { super.required = true });

  @override
  String? Function(String? p1)? get validator => !this.required ? null : InputValidator.emailValidator;

  @override
  TextInputType get textInputType => TextInputType.emailAddress;

}

//  Multi Line Form Field Controller
//  This controller used for multiline text field like description, address.
//
//  [Param]
//  * key - resourceId
//
//  [Optional Param]
//  * minLines - length of the lines in text field, default will be 3
//  * required - default will be false
//
class MultiLineFormFieldController extends FormFieldController {

  MultiLineFormFieldController(super.fieldKey,  { super.required, super.minLines = 3 });

  @override
  String? Function(String? p1)? get validator => !this.required ? null : super.validator;

  @override
  TextInputType get textInputType => TextInputType.multiline;

  @override
  TextCapitalization get textCapitalization => TextCapitalization.sentences;
}

//  Name Form Field Controller
//  This controller used for name text field like Full Name, Last Name.
//
//  [Param]
//  * key - resourceId
//
//  [Optional Param]
//  * required - default will be true
//
class NameFormFieldController extends FormFieldController {

  NameFormFieldController(super.fieldKey,  { super.required = true });

  @override
  String? Function(String? p1)? get validator => !this.required ? null : InputValidator.nameValidator;

  @override
  TextInputType get textInputType => TextInputType.name;

  @override
  List<TextInputFormatter> get inputFormatter => InputFormatter.nameFormatter;

  @override
  TextCapitalization get textCapitalization => TextCapitalization.words;

}

//  Number Form Field Controller
//  This controller used for number text field like Amount, Quantity, Age etc.
//
//  [Param]
//  * key - resourceId
//
//  [Optional Param]
//  * required - default will be false
//
class NumberFormFieldController extends FormFieldController {

  NumberFormFieldController(super.fieldKey,  { super.required });

  @override
  String? Function(String? p1)? get validator => !this.required ? null : InputValidator.numberValidator;

  @override
  TextInputType get textInputType => TextInputType.numberWithOptions(decimal: true);

  @override
  TextCapitalization get textCapitalization => TextCapitalization.sentences;

}

//  Text Form Field Controller
//  This controller is the default controller that can be used for normal text. it allows any character.
//
//  [Param]
//  * key - resourceId
//
//  [Optional Param]
//  * required - default will be false
//
class TextFormFieldController extends FormFieldController {

  TextInputType? inputType;

  TextCapitalization? textCapital;

  TextFormFieldController(super.fieldKey,  { super.required, this.inputType, this.textCapital });

  @override
  String? Function(String? p1)? get validator => !this.required ? null : super.validator;

  @override
  TextInputType get textInputType => inputType??  TextInputType.text;

  @override
  TextCapitalization get textCapitalization => textCapital?? TextCapitalization.sentences;

}

class FormFieldController {

  Key fieldKey;

  TextEditingController textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  TextCapitalization textCapitalization = TextCapitalization.none;

  String? Function(String?)? validator = InputValidator.emptyValidator;
  List<TextInputFormatter> inputFormatter = InputFormatter.defaultFormatter;

  TextInputType textInputType;

  bool required;

  int maxLength;
  int minLines;
  int maxLines;

  String get text => textEditingController.text;

  set text(value) {
    textEditingController.text = value;
  }

  clear() {
    textEditingController.clear();
  }

  FocusNode get focusNode => _focusNode;

  bool get hasFocus => focusNode.hasFocus;

  FormFieldController(this.fieldKey, {
    this.textInputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.validator = InputValidator.emptyValidator,
    this.inputFormatter = const [],
    this.maxLength = 1000,
    this.minLines = 1,
    this.maxLines = 1000,
    this.required = false
  });

}

// class DropdownFieldController<T extends BaseObject> {
//
//   Key fieldKey;
//   FocusNode focusNode = new FocusNode();
//   T? value;
//   List<T> dataList;
//   String keyId;
//   String valueId;
//   bool required;
//
//   DropdownFieldController(this.fieldKey, { required this.keyId, required this.valueId, this.dataList = const [], this.value, this.required = true });
//
//   String? validator(T? value) {
//     if (value == null && required)
//       return "Required !";
//
//     return null;
//   }
//
//   setValue(T? value) {
//     this.value = value;
//   }
//
//   List<T> get list => dataList;
//
//   set list(List<T> list) {
//     this.dataList = list;
//   }
//
// }

class ImageFieldController {

  Key fieldKey;
  FocusNode focusNode = FocusNode();
  String? value;
  bool required;

  ImageFieldController(this.fieldKey, { this.value, this.required = true });

  setValue(String value){
    this.value = value;
  }

  String? validator(String? value) {
    if (required && value == null) {
      return "Required !";
    }

    return null;
  }

}
