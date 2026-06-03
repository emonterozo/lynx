import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../core/theme.dart';

class CustomDatePickerField extends StatelessWidget {
  final String label;
  final String hint;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? Function(DateTime?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.validator,
    this.firstDate,
    this.lastDate,
  });

  // Helper method to format date cleanly (e.g., "Jun 03, 2026")
  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    return '$month $day, ${date.year}';
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: LynxTheme.mutedForeground,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: LynxTheme.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      
      // Right side calendar icon replacing the downward arrow
      suffixIcon: const Padding(
        padding: EdgeInsets.only(right: 16),
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedCalendar01,
          color: LynxTheme.mutedForeground,
          size: 20,
        ),
      ),
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: LynxTheme.primary, width: 1.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: LynxTheme.primary, width: 1.3),
      ),
      errorStyle: const TextStyle(
        color: LynxTheme.error,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Future<void> _showNativeDatePicker(BuildContext context, FormFieldState<DateTime> state) async {
    final DateTime now = DateTime.now();
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: LynxTheme.primary,
              onPrimary: Colors.white,
              surface: LynxTheme.card,
              onSurface: LynxTheme.foreground,
            ),
            dialogBackgroundColor: LynxTheme.background,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onChanged(picked);
      state.didChange(picked); // Forces the FormField status validation to update immediately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: LynxTheme.mutedForeground,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        FormField<DateTime>(
          initialValue: value,
          validator: validator,
          builder: (FormFieldState<DateTime> state) {
            return GestureDetector(
              onTap: () => _showNativeDatePicker(context, state),
              child: InputDecorator(
                decoration: _inputDecoration().copyWith(
                  errorText: state.errorText,
                ),
                isEmpty: value == null,
                child: value != null
                    ? Text(
                        _formatDate(value!),
                        style: const TextStyle(
                          color: LynxTheme.foreground,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}