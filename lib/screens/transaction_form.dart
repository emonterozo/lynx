import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:isar/isar.dart';
import 'package:lynx/data/models/transaction.dart'
    show GetTransactionCollection, Transaction;
import '../core/enums/app_enums.dart';
import '../core/theme.dart';
import '../core/utils/currency_input_formatter.dart';
import '../core/utils/number_utils.dart';
import '../data/models/credit_card.dart';
import '../data/models/person.dart';
import '../data/models/wallet.dart';
import '../presentation/models/source_item.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_date_picker_field.dart';
import '../widgets/custom_dropdown_field.dart';
import '../widgets/custom_text_field.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _WalletFormState();
}

class _WalletFormState extends State<TransactionForm> {
  List<Wallet> wallets = [];
  List<CreditCard> creditCards = [];
  List<Person> persons = [];
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _transferFeeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  FlowType _selectedFlowType = FlowType.expense;
  TransactionType? _selectedTransactionType;
  final isar = GetIt.I<Isar>();
  SourceItem? _selectedSource;
  SourceItem? _selectedDestination;

  List<SourceItem> buildSources() {
    final walletSources = wallets.map(
      (w) => SourceItem(
        id: w.id,
        name: w.name,
        type: SourceType.wallet,
        icon: w.type.icon,
      ),
    );

    final creditCardSources = creditCards.map(
      (c) => SourceItem(
        id: c.id,
        name: c.name,
        type: SourceType.creditCard,
        icon: HugeIcons.strokeRoundedCreditCard,
      ),
    );

    final personSources = persons.map(
      (p) => SourceItem(
        id: p.id,
        name: p.name,
        type: SourceType.person,
        icon: HugeIcons.strokeRoundedUser,
      ),
    );

    return [...walletSources, ...creditCardSources, ...personSources];
  }

  List<SourceItem> filterSources(
    List<SourceItem> all,
    FlowType flow, {
    bool isDestination = false,
  }) {
    switch (flow) {
      case FlowType.income:
        return all.where((e) => e.type == SourceType.wallet).toList();

      case FlowType.expense:
        return all.where((e) => e.type != SourceType.person).toList();

      case FlowType.transfer:
        if (isDestination) {
          return all.where((e) => e.type != SourceType.creditCard).toList();
        }
        return all;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWallets();
  }

  Future<void> _loadWallets() async {
    final isar = Isar.getInstance()!;

    final walletResult = await isar.wallets.where().findAll();
    final creditCardResult = await isar.creditCards.where().findAll();
    final personResult = await isar.persons.where().findAll();

    if (!mounted) return;

    setState(() {
      wallets = walletResult;
      creditCards = creditCardResult;
      persons = personResult;
    });
  }

  Future<void> _createTransaction() async {
    final double parsedAmount = NumberUtils.parseAmount(_amountController.text);
    final double parsedTransferFee = NumberUtils.parseAmount(
      _transferFeeController.text,
    );

    if (parsedAmount <= 0) {
      throw Exception("Amount must be greater than zero");
    }

    try {
      await isar.writeTxn(() async {
        Wallet? sourceWallet;
        CreditCard? sourceCreditCard;
        Person? sourcePerson;
        Wallet? destinationWallet;
        Person? destinationPerson;

        if (_selectedFlowType == FlowType.income) {
          sourceWallet = await isar.wallets.get(_selectedSource!.id);
          sourceWallet!.balance += parsedAmount;
          await isar.wallets.put(sourceWallet);
        } else if (_selectedFlowType == FlowType.expense) {
          if (_selectedSource!.type == SourceType.wallet) {
            sourceWallet = await isar.wallets.get(_selectedSource!.id);
            if (sourceWallet!.balance < parsedAmount) {
              throw Exception("Insufficient balance");
            }
            sourceWallet.balance -= parsedAmount;
            await isar.wallets.put(sourceWallet);
          } else {
            sourceCreditCard = await isar.creditCards.get(_selectedSource!.id);
            sourceCreditCard!.balance += parsedAmount;
            await isar.creditCards.put(sourceCreditCard);
          }
        } else {
          final deduction = parsedAmount + parsedTransferFee;
          if (_selectedSource!.type == SourceType.wallet) {
            sourceWallet = await isar.wallets.get(_selectedSource!.id);
            if (sourceWallet!.balance < deduction) {
              throw Exception("Insufficient balance");
            }
            sourceWallet.balance -= deduction;
            await isar.wallets.put(sourceWallet);
          } else if (_selectedSource!.type == SourceType.creditCard) {
            sourceCreditCard = await isar.creditCards.get(_selectedSource!.id);
            sourceCreditCard!.balance += deduction;
            await isar.creditCards.put(sourceCreditCard);
          } else {
            sourcePerson = await isar.persons.get(_selectedSource!.id);
            sourcePerson!.balance = (sourcePerson.balance - deduction).clamp(
              0,
              double.infinity,
            );
            await isar.persons.put(sourcePerson);
          }

          if (_selectedDestination!.type == SourceType.wallet) {
            destinationWallet = await isar.wallets.get(
              _selectedDestination!.id,
            );
            destinationWallet!.balance += parsedAmount;
            await isar.wallets.put(destinationWallet);
          } else {
            destinationPerson = await isar.persons.get(
              _selectedDestination!.id,
            );
            destinationPerson!.balance += parsedAmount;
            await isar.persons.put(destinationPerson);
          }
        }

        final newTransaction = Transaction.create(
          amount: parsedAmount,
          fee: parsedTransferFee,
          date: _selectedDate,
          note: _descriptionController.text.trim(),
          type: _selectedTransactionType!,
          flowType: _selectedFlowType,
          source: _selectedSource!,
          sourceId: _selectedSource!.id,
          destination: _selectedDestination,
          destinationId: _selectedDestination?.id,
        );
        await isar.transactions.put(newTransaction);
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: LynxTheme.error),
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
      appBar: CustomAppBar(title: "Add Transaction"),
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
                        CustomDropdownField<FlowType>(
                          label: "Transaction Type",
                          hint: "Select wallet type",
                          value: _selectedFlowType,
                          items: FlowType.values,
                          itemLabelBuilder: (type) => type.label,
                          itemIconBuilder: (type) => HugeIcon(
                            icon: type.icon,
                            color: LynxTheme.primary,
                            size: 20,
                          ),
                          onChanged: (val) {
                            if (val != null) {
                              if (val == FlowType.transfer) {
                                _descriptionController.text = "Transfer";
                              }
                              setState(() {
                                _selectedFlowType = val;
                                _selectedTransactionType =
                                    val == FlowType.transfer
                                    ? TransactionType.transfer
                                    : null;
                              });
                            }
                          },
                        ),
                        if (_selectedFlowType != FlowType.transfer) ...[
                          const SizedBox(height: 16),
                          CustomDropdownField<TransactionType>(
                            key: ValueKey(
                              'category_${_selectedTransactionType?.name ?? 'none'}',
                            ),
                            label: "Category",
                            hint: "Select category",
                            value: _selectedTransactionType,
                            items: TransactionType.values,
                            itemLabelBuilder: (type) => type.label,
                            itemIconBuilder: (type) => HugeIcon(
                              icon: type.icon,
                              color: LynxTheme.primary,
                              size: 20,
                            ),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedTransactionType = val;
                                });
                              }
                            },
                            validator: (val) =>
                                val == null ? "Please select a category" : null,
                          ),
                        ],
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Amount",
                          hint: "0.00",
                          controller: _amountController,
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
                          validator: (val) =>
                              val!.isEmpty ? "Please enter a amount" : null,
                        ),
                        if (_selectedFlowType == FlowType.transfer) ...[
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: "Transfer fee",
                            hint: "0.00",
                            controller: _transferFeeController,
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
                          ),
                        ],
                        const SizedBox(height: 16),
                        CustomDropdownField<SourceItem>(
                          key: ValueKey(
                            'source${_selectedSource?.id ?? 'none'}',
                          ),
                          label: "Source account",
                          hint: "Select source account",
                          value: _selectedSource,
                          items:
                              filterSources(buildSources(), _selectedFlowType)
                                  .where(
                                    (item) =>
                                        item.id != _selectedDestination?.id,
                                  )
                                  .toList(),
                          itemLabelBuilder: (item) => item.name,
                          itemIconBuilder: (item) => HugeIcon(
                            icon: item.icon,
                            color: LynxTheme.primary,
                            size: 20,
                          ),
                          onChanged: (val) {
                            setState(() => _selectedSource = val);
                          },
                        ),
                        if (_selectedFlowType == FlowType.transfer) ...[
                          const SizedBox(height: 16),
                          CustomDropdownField<SourceItem>(
                            key: ValueKey(
                              'destination_${_selectedDestination?.id ?? 'none'}',
                            ),
                            label: "Destination wallet",
                            hint: "Select destination wallet",
                            value: _selectedDestination,
                            items:
                                filterSources(
                                      buildSources(),
                                      _selectedFlowType,
                                      isDestination: true,
                                    )
                                    .where(
                                      (item) => item.id != _selectedSource?.id,
                                    )
                                    .toList(),
                            itemLabelBuilder: (item) => item.name,
                            itemIconBuilder: (item) => HugeIcon(
                              icon: item.icon,
                              color: LynxTheme.primary,
                              size: 20,
                            ),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedDestination = val;
                                });
                              }
                            },
                            validator: (val) => val == null
                                ? "Please select a destination wallet"
                                : null,
                          ),
                        ],
                        const SizedBox(height: 16),
                        CustomDatePickerField(
                          label: "Transaction date",
                          hint: "Select transaction date",
                          includeTime: false,
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
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Description",
                          hint: "Enter description",
                          controller: _descriptionController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Please enter a description";
                            }
                            return null;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25),
                          ],
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _createTransaction();
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
                            "Create Transaction",
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
