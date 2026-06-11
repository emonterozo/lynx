import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:isar/isar.dart';
import '../core/enums/app_enums.dart';
import '../core/theme.dart';
import '../core/utils/currency_input_formatter.dart';
import '../data/models/wallet.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_date_picker_field.dart';
import '../widgets/custom_dropdown_field.dart';
import '../widgets/custom_text_field.dart';

class WalletForm extends StatefulWidget {
  const WalletForm({super.key});

  @override
  State<WalletForm> createState() => _WalletFormState();
}

class _WalletFormState extends State<WalletForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _nameFieldError;
  final _balanceController = TextEditingController();
  final _goalAmountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  WalletType _selectedWalletType = WalletType.general;
  String? _goalAmountError;
  String? _startDateError;
  String? _endDateError;
  final isar = GetIt.I<Isar>();

  Future<void> _createWallet() async {
    final walletName = _nameController.text.trim();

    final existingWallet = await isar.wallets
        .filter()
        .nameEqualTo(walletName, caseSensitive: false)
        .findFirst();

    if (existingWallet != null) {
      setState(() {
        _nameFieldError = "Wallet name already exists";
      });

      _formKey.currentState!.validate();
      return;
    }

    setState(() => _nameFieldError = null);

    final rawBalanceString = _balanceController.text.replaceAll(',', '');
    final double parsedBalance = double.tryParse(rawBalanceString) ?? 0.0;

    final rawGoalAmountString = _goalAmountController.text
        .replaceAll(',', '')
        .trim();

    final double? parsedGoalAmount = rawGoalAmountString.isNotEmpty
        ? double.tryParse(rawGoalAmountString)
        : null;

    final newWallet = Wallet.create(
      name: walletName,
      balance: parsedBalance,
      showBalance: true,
      type: _selectedWalletType,
      goalAmount: parsedGoalAmount,
      startDate: _startDate,
      endDate: _endDate,
    );

    try {
      await isar.writeTxn(() async {
        await isar.wallets.put(newWallet);
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save wallet. Please try again."),
            backgroundColor: LynxTheme.error,
          ),
        );
      }
    }
  }

  void _onSavePressed() {
    setState(() {
      _goalAmountError = null;
      _startDateError = null;
      _endDateError = null;
    });

    final bool isFormValid = _formKey.currentState!.validate();

    bool isCustomValid = true;

    if (_selectedWalletType == WalletType.goals) {
      final String goalText = _goalAmountController.text.trim();
      final bool hasGoalAmount =
          goalText.isNotEmpty && goalText != "0.00" && goalText != "0";
      final bool hasEndDate = _endDate != null;

      if (!hasGoalAmount && !hasEndDate) {
        setState(() {
          _goalAmountError =
              "Please enter a goal amount or select goal end date";
          _endDateError = "Please select goal end date or enter a goal amount";
        });
        isCustomValid = false;
      }

      if (_startDate == null) {
        setState(() {
          _startDateError = "Please select goal start date";
        });
        isCustomValid = false;
      }
    } else if (_selectedWalletType == WalletType.timeDeposit) {
      if (_startDate == null) {
        setState(() {
          _startDateError = "Please select placement date";
        });
        isCustomValid = false;
      }

      if (_endDate == null) {
        setState(() {
          _endDateError = "Please select maturity date";
        });
        isCustomValid = false;
      }
    }
    _formKey.currentState!.validate();

    if (isFormValid && isCustomValid) {
      _createWallet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    return Scaffold(
      backgroundColor: LynxTheme.background,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: "Add Wallet"),
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
                          label: "Wallet name",
                          hint: "Enter wallet name",
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
                              return "Please enter a wallet name";
                            }
                            return _nameFieldError;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Wallet balance",
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
                              ? "Please enter a wallet balance"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomDropdownField<WalletType>(
                          label: "Wallet Type",
                          hint: "Select wallet type",
                          value: _selectedWalletType,
                          items: WalletType.values,
                          itemLabelBuilder: (type) => type.label,
                          itemIconBuilder: (type) => HugeIcon(
                            icon: type.icon,
                            color: LynxTheme.primary,
                            size: 20,
                          ),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedWalletType = val;
                                _goalAmountController.clear();
                                _startDate = null;
                                _endDate = null;
                                _goalAmountError = null;
                                _startDateError = null;
                                _endDateError = null;
                              });
                            }
                          },
                        ),
                        if (_selectedWalletType == WalletType.goals) ...[
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: "Goal Amount",
                            hint: "0.00",
                            controller: _goalAmountController,
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
                            onChanged: (value) {
                              if (_goalAmountError != null) {
                                setState(() {
                                  _goalAmountError = null;
                                  _endDateError = null;
                                });
                              }
                              _formKey.currentState!.validate();
                            },
                            validator: (_) {
                              return _goalAmountError;
                            },
                          ),
                        ],
                        if (_selectedWalletType == WalletType.goals ||
                            _selectedWalletType == WalletType.timeDeposit) ...[
                          const SizedBox(height: 16),
                          CustomDatePickerField(
                            label: _selectedWalletType == WalletType.goals
                                ? "Goal start date"
                                : "Placement date",
                            hint: _selectedWalletType == WalletType.goals
                                ? "Select goal start date"
                                : "Select placement date",
                            value: _startDate,
                            lastDate: DateTime.now(),
                            onChanged: (DateTime? date) {
                              setState(() {
                                _startDate = date;
                                _startDateError = null;
                              });
                              _formKey.currentState!.validate();
                            },
                            validator: (_) {
                              return _startDateError;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomDatePickerField(
                            label: _selectedWalletType == WalletType.goals
                                ? "Goal end date"
                                : "Maturity date",
                            hint: _selectedWalletType == WalletType.goals
                                ? "Select goal end date"
                                : "Select maturity date",
                            value: _endDate,
                            firstDate: DateTime.now(),
                            onChanged: (DateTime? date) {
                              setState(() {
                                _endDate = date;
                                _endDateError = null;
                                _goalAmountError = null;
                              });
                              _formKey.currentState!.validate();
                            },
                            validator: (_) {
                              return _endDateError;
                            },
                          ),
                        ],
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
                      onPressed: _onSavePressed,
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
                            "Create Wallet",
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
