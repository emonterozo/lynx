import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../core/theme.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final Widget Function(T)? itemIconBuilder;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.itemIconBuilder,
    this.validator,
  });

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
      suffixIcon: const Padding(
        padding: EdgeInsets.only(right: 16),
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedArrowDown01,
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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: LynxTheme.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: LynxTheme.mutedForeground.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: LynxTheme.mutedForeground,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item == value;

                    return ListTile(
                      leading: itemIconBuilder != null
                          ? itemIconBuilder!(item)
                          : null,
                      title: Text(
                        itemLabelBuilder(item),
                        style: TextStyle(
                          color: isSelected
                              ? LynxTheme.primary
                              : LynxTheme.foreground,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected
                          ? const HugeIcon(
                              icon: HugeIcons.strokeRoundedTick01,
                              color: LynxTheme.primary,
                            )
                          : null,
                      onTap: () {
                        onChanged(item);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
        FormField<T>(
          initialValue: value,
          validator: validator,
          builder: (FormFieldState<T> state) {
            return GestureDetector(
              onTap: () => _showBottomSheet(context),
              child: InputDecorator(
                decoration: _inputDecoration().copyWith(
                  errorText: state.errorText,
                ),
                isEmpty: value == null,
                child: value != null
                    ? Row(
                        children: [
                          if (itemIconBuilder != null) ...[
                            itemIconBuilder!(value as T),
                            const SizedBox(width: 12),
                          ],
                          Text(
                            itemLabelBuilder(value as T),
                            style: const TextStyle(
                              color: LynxTheme.foreground,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
