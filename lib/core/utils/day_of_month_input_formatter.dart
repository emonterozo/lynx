import 'package:flutter/services.dart';

class DayOfMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final filtered = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (filtered.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final value = int.tryParse(filtered);

    if (value == null || value < 1) {
      return const TextEditingValue(text: '1');
    } else if (value > 31) {
      return const TextEditingValue(text: '31');
    }

    return TextEditingValue(
      text: value.toString(),
      selection: TextSelection.collapsed(offset: value.toString().length),
    );
  }
}
