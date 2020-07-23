import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class NumberPrefixInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {

    final StringBuffer newText = StringBuffer();
    if(newValue.text.isEmpty) {
      newText.write("+");
    } else {
      newText.write(newValue.text);
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length)
    );
  }
}
