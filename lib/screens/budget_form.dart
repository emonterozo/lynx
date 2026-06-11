import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:isar/isar.dart';
import 'package:lynx/data/models/budget.dart';
import '../core/enums/app_enums.dart';
import '../core/theme.dart';
import '../core/utils/currency_input_formatter.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_date_picker_field.dart';
import '../widgets/custom_dropdown_field.dart';
import '../widgets/custom_text_field.dart';

class BudgetForm extends StatefulWidget {
  const BudgetForm({super.key});

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final List<TransactionType> budgetTypes = [
    TransactionType.utilities,
    TransactionType.groceries,
    TransactionType.transport,
    TransactionType.food,
    TransactionType.entertainment,
    TransactionType.shopping,
    TransactionType.others,
  ];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _nameFieldError;
  final _budgetLimitController = TextEditingController();
  TransactionType _selectedTransactionType = TransactionType.utilities;
  CycleType _selectedCycleType = CycleType.weekly;
  DateTime _selectedDate = DateTime.now();
  final isar = GetIt.I<Isar>();

  Future<void> _createBudget() async {
    final budgetName = _nameController.text.trim();

    final existingBudget = await isar.budgets
        .filter()
        .nameEqualTo(budgetName, caseSensitive: false)
        .findFirst();

    if (existingBudget != null) {
      setState(() {
        _nameFieldError = "Budget name already exists";
      });

      _formKey.currentState!.validate();
      return;
    }

    setState(() => _nameFieldError = null);

    final rawBudgetLimitString = _budgetLimitController.text.replaceAll(
      ',',
      '',
    );
    final double parsedBudgetLimit =
        double.tryParse(rawBudgetLimitString) ?? 0.0;

    final newBudget = Budget()
      ..name = budgetName
      ..limitAmount = parsedBudgetLimit
      ..type = _selectedTransactionType
      ..cycleType = _selectedCycleType
      ..startDate = _selectedDate;

    try {
      await isar.writeTxn(() async {
        await isar.budgets.put(newBudget);
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save budget. Please try again."),
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
      appBar: CustomAppBar(title: "Add Budget"),
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
                          label: "Budget name",
                          hint: "Enter budget name",
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
                              return "Please enter a budget name";
                            }
                            return _nameFieldError;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Budget limit",
                          hint: "0.00",
                          controller: _budgetLimitController,
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
                              ? "Please enter a budget limit"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomDropdownField<TransactionType>(
                          label: "Budget category",
                          hint: "Select budget category",
                          value: _selectedTransactionType,
                          items: budgetTypes,
                          itemLabelBuilder: (type) => type.label,
                          itemIconBuilder: (type) => HugeIcon(
                            icon: type.icon,
                            color: LynxTheme.primary,
                            size: 20,
                          ),
                          onChanged: (val) {
                            setState(() => _selectedTransactionType = val!);
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomDropdownField<CycleType>(
                          label: "Budget cycle",
                          hint: "Select budget cycle",
                          value: _selectedCycleType,
                          items: CycleType.values,
                          itemLabelBuilder: (type) => type.label,
                          itemIconBuilder: (type) => HugeIcon(
                            icon: type.icon,
                            color: LynxTheme.primary,
                            size: 20,
                          ),
                          onChanged: (val) {
                            setState(() => _selectedCycleType = val!);
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomDatePickerField(
                          label: "Budget start date",
                          hint: "Select budget start date",
                          value: _selectedDate,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 31),
                          ),
                          lastDate: DateTime.now(),
                          onChanged: (DateTime? date) {
                            setState(() {
                              _selectedDate = date!;
                            });
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
                          _createBudget();
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
                            "Create Budget",
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
