import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../core/theme.dart';

class CustomDatePickerField extends StatelessWidget {
  final String? label;
  final String hint;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? Function(DateTime?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool includeTime;
  final bool showClearButton;

  const CustomDatePickerField({
    super.key,
    this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.includeTime = false,
    this.showClearButton = false,
  });

  String _formatDateTime(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final month = months[date.month - 1];
    final day = date.day.toString().padLeft(2, '0');

    if (!includeTime) {
      return '$month $day, ${date.year}';
    }

    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$month $day, ${date.year} • $hour:$minute $period';
  }

  InputDecoration _inputDecoration(BuildContext context) {
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
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (value != null && showClearButton == true) ...[
              GestureDetector(
                onTap: () => onChanged(null),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendarRemove01,
                  size: 20,
                  color: LynxTheme.error,
                ),
              ),
              const SizedBox(width: 10),
            ],
            HugeIcon(
              icon: includeTime
                  ? HugeIcons.strokeRoundedClock01
                  : HugeIcons.strokeRoundedCalendar01,
              color: LynxTheme.mutedForeground,
              size: 20,
            ),
          ],
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
      errorMaxLines: 2,
      errorStyle: const TextStyle(
        color: LynxTheme.error,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Future<void> _showPicker(
    BuildContext context,
    FormFieldState<DateTime> state,
  ) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
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

    if (pickedDate == null) return;

    DateTime selectedDateTime = includeTime
        ? pickedDate
        : DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            now.hour,
            now.minute,
            now.second,
            now.millisecond,
            now.microsecond,
          );

    if (includeTime) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: value != null
            ? TimeOfDay.fromDateTime(value!)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }

    onChanged(selectedDateTime);
    state.didChange(selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              color: LynxTheme.mutedForeground,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
        ],
        FormField<DateTime>(
          initialValue: value,
          validator: validator,
          builder: (state) {
            return GestureDetector(
              onTap: () => _showPicker(context, state),
              child: InputDecorator(
                decoration: _inputDecoration(
                  context,
                ).copyWith(errorText: state.errorText),
                isEmpty: value == null,
                child: value != null
                    ? Text(
                        _formatDateTime(value!),
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
