import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? prefix;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final _fieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleTextChange);
      widget.controller.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    if (_fieldKey.currentState?.hasError ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _fieldKey.currentState?.validate();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: LynxTheme.mutedForeground,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          key: _fieldKey,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: TextInputAction.done,
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          style: const TextStyle(
            color: LynxTheme.foreground,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: _inputDecoration(
            hint: widget.hint,
            prefix: widget.prefix,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({required String hint, Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: LynxTheme.mutedForeground,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      prefix: prefix,
      filled: true,
      fillColor: LynxTheme.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
}
