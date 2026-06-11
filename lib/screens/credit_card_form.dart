import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:isar/isar.dart';
import 'package:lynx/core/utils/day_of_month_input_formatter.dart';
import 'package:lynx/data/models/credit_card.dart';
import '../core/theme.dart';
import '../core/utils/currency_input_formatter.dart';
import '../core/utils/number_utils.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_field.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({super.key});

  @override
  State<CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _nameFieldError;
  final _fourDigitController = TextEditingController();
  final _balanceController = TextEditingController();
  final _billingDayController = TextEditingController();
  final isar = GetIt.I<Isar>();

  Future<void> _createCreditCard() async {
    final creditCardName = _nameController.text.trim();

    final existingCreditCard = await isar.creditCards
        .filter()
        .nameEqualTo(creditCardName, caseSensitive: false)
        .findFirst();

    if (existingCreditCard != null) {
      setState(() {
        _nameFieldError = "Credit card name already exists";
      });

      _formKey.currentState!.validate();
      return;
    }

    setState(() => _nameFieldError = null);

    final newCreditCard = CreditCard()
      ..name = creditCardName
      ..lastFourDigits = _fourDigitController.text.trim()
      ..balance = NumberUtils.parseAmount(_balanceController.text)
      ..statementBalance = 0
      ..billingCycleDay = int.parse(_billingDayController.text.trim())
      ..showBalance = true;

    try {
      await isar.writeTxn(() async {
        await isar.creditCards.put(newCreditCard);
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save credit card. Please try again."),
            backgroundColor: LynxTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    return Scaffold(
      backgroundColor: LynxTheme.background,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: "Add Credit Card"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          label: "Credit card name",
                          hint: "Enter credit card name",
                          controller: _nameController,
                          onChanged: (val) {
                            if (_nameFieldError != null) {
                              setState(() {
                                _nameFieldError = null;
                              });
                              _formKey.currentState!.validate();
                            }
                          },
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Please enter credit card name";
                            }
                            return _nameFieldError;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Credit card last four digits",
                          hint: "Enter credit card last four digits",
                          keyboardType: const TextInputType.numberWithOptions(),
                          controller: _fourDigitController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          validator: (val) => val!.isEmpty
                              ? "Please enter credit card last four digits"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Credit card balance",
                          hint: "0.00",
                          controller: _balanceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          prefix: const Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Text(
                              "₱",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: LynxTheme.foreground,
                              ),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[\d.,]'),
                            ),
                            CurrencyInputFormatter(),
                          ],
                          validator: (val) => val!.isEmpty
                              ? "Please enter credit card balance"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Credit card billing cycle day",
                          hint: "15th of the month",
                          controller: _billingDayController,
                          keyboardType: const TextInputType.numberWithOptions(),
                          prefix: const Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Text(
                              "Every",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: LynxTheme.foreground,
                              ),
                            ),
                          ),
                          inputFormatters: [DayOfMonthInputFormatter()],
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please enter credit card billing cycle day";
                            }
                            final num = int.tryParse(val);
                            if (num == null || num < 1 || num > 31) {
                              return "Day must be between 1 and 31";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                if (!isKeyboardOpen) ...[
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: LynxTheme.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _createCreditCard();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LynxTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedSent,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Create Credit Card",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
