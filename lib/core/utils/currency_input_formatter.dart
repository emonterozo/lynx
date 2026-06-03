import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    if (newValue.text == '.') {
      return newValue.copyWith(
        text: '0.',
        selection: const TextSelection.collapsed(offset: 2),
      );
    }

    String cleanText = newValue.text.replaceAll(',', '');

    List<String> parts = cleanText.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    final formatter = NumberFormat('#,###', 'en_US');
    String formattedInteger = '';

    if (integerPart.isNotEmpty) {
      double? number = double.tryParse(integerPart);
      if (number != null) {
        formattedInteger = formatter.format(number);
      }
    }

    String finalText = formattedInteger;
    if (cleanText.contains('.')) {
      if (decimalPart.length > 2) {
        decimalPart = decimalPart.substring(0, 2);
      }
      finalText += '.$decimalPart';
    }

    int cursorPosition = newValue.selection.baseOffset;
    int oldCommaCount = oldValue.text.split(',').length - 1;
    int newCommaCount = finalText.split(',').length - 1;
    cursorPosition += (newCommaCount - oldCommaCount);

    if (cursorPosition < 0) cursorPosition = 0;
    if (cursorPosition > finalText.length) cursorPosition = finalText.length;

    return TextEditingValue(
      text: finalText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
