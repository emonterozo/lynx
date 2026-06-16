import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:isar/isar.dart';
import 'package:lynx/data/models/transaction.dart'
    show GetTransactionCollection, Transaction;
import '../core/enums/app_enums.dart';
import '../core/services/transaction_service.dart';
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
  final Id? transactionId;
  const TransactionForm({super.key, this.transactionId});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final formatter = CurrencyInputFormatter();
  List<Wallet> wallets = [];
  List<CreditCard> creditCards = [];
  List<Person> persons = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _transferFeeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  FlowType _selectedFlowType = FlowType.expense;
  TransactionType? _selectedTransactionType;
  final isar = GetIt.I<Isar>();
  SourceItem? _selectedSource;
  SourceItem? _selectedDestination;
  Transaction? _transaction;

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

  SourceItem? getSourceByFlowAndId(
    FlowType flow,
    Id id,
    List<SourceItem> allSources, {
    bool isDestination = false,
  }) {
    final sources = filterSources(
      allSources,
      flow,
      isDestination: isDestination,
    );

    try {
      return sources.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
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

    if (widget.transactionId != null) {
      final transaction = await isar.transactions.get(
        widget.transactionId as Id,
      );
      if (transaction != null) {
        setState(() {
          _selectedFlowType = transaction.flowType;
          _selectedTransactionType = transaction.type;
          _selectedDate = transaction.date;
          _transaction = transaction;
        });
        _amountController = TextEditingController(
          text: CurrencyInputFormatter.formatValue(transaction.amount),
        );
        _descriptionController = TextEditingController(text: transaction.note);
        _transferFeeController = TextEditingController(
          text: CurrencyInputFormatter.formatValue(transaction.fee!),
        );

        final source = getSourceByFlowAndId(
          transaction.flowType,
          transaction.sourceId,
          buildSources(),
        );
        _selectedSource = source;

        if (transaction.flowType == FlowType.transfer) {
          final destination = getSourceByFlowAndId(
            transaction.flowType,
            transaction.destinationId!,
            buildSources(),
            isDestination: true,
          );
          _selectedDestination = destination;
        }
      }
    }
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    await isar.writeTxn(() async {
      await TransactionService(isar).reverse(transaction);
      await isar.transactions.delete(transaction.id);
    });
    if (mounted) Navigator.pop(context);
  }

  Future<void> _createTransaction() async {
    final amount = NumberUtils.parseAmount(_amountController.text);
    final fee = NumberUtils.parseAmount(_transferFeeController.text);

    try {
      final tx = Transaction.create(
        amount: amount,
        fee: fee,
        date: _selectedDate,
        note: _descriptionController.text.trim(),
        type: _selectedTransactionType!,
        flowType: _selectedFlowType,
        source: _selectedSource!,
        sourceId: _selectedSource!.id,
        destination: _selectedDestination,
        destinationId: _selectedDestination?.id,
      );

      await isar.writeTxn(() async {
        await TransactionService(isar).apply(tx);
        await isar.transactions.put(tx);
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

  Future<void> _updateTransaction(Transaction oldTx) async {
    final amount = NumberUtils.parseAmount(_amountController.text);
    final fee = NumberUtils.parseAmount(_transferFeeController.text);

    final transaction = Transaction.create(
      amount: amount,
      fee: fee,
      date: _selectedDate,
      note: _descriptionController.text.trim(),
      type: _selectedTransactionType!,
      flowType: _selectedFlowType,
      source: _selectedSource!,
      sourceId: _selectedSource!.id,
      destination: _selectedDestination,
      destinationId: _selectedDestination?.id,
    );

    if (oldTx.flowType != transaction.flowType) {
      throw Exception("Flow type cannot be changed");
    }

    transaction.id = oldTx.id;
    await isar.writeTxn(() async {
      await TransactionService(isar).reverse(oldTx);
      await TransactionService(isar).apply(transaction);
      await isar.transactions.put(transaction);
    });
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    return Scaffold(
      backgroundColor: LynxTheme.background,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: widget.transactionId == null
            ? "Add Transaction"
            : "Transaction Details",
      ),
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
                          enabled: _transaction == null,
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
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Please enter an amount";
                            }

                            final amount = NumberUtils.parseAmount(val);

                            if (amount <= 0) {
                              return "Amount must be greater than 0";
                            }

                            return null;
                          },
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
                            label: "Destination account",
                            hint: "Select destination account",
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
                  Column(
                    children: [
                      if (_transaction != null) ...[
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
                              _updateTransaction(_transaction!);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: LynxTheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedSent,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Update Transaction",
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
                        SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: LynxTheme.error.withValues(alpha: 0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: OutlinedButton(
                            onPressed: () {
                              _deleteTransaction(_transaction!);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: LynxTheme.error,
                              side: const BorderSide(
                                color: LynxTheme.error,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: LynxTheme.error,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Delete Transaction",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: LynxTheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (_transaction == null) ...[
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
                            child: Row(
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
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
