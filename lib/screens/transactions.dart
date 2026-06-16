import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:isar/isar.dart';
import '../core/enums/app_enums.dart';
import '../core/theme.dart';
import '../data/models/credit_card.dart';
import '../data/models/person.dart';
import '../data/models/transaction.dart';
import '../data/models/wallet.dart';
import '../presentation/models/transaction_with_source.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_date_picker_field.dart';
import '../widgets/transaction_card.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final Isar _isar = Isar.getInstance()!;
  DateTime? selectedDate;
  final List<TransactionWithSource> transactions = [];
  final ScrollController _controller = ScrollController();

  bool isLoading = false;
  bool hasMore = true;
  int offset = 0;
  final int limit = 50;

  @override
  void initState() {
    super.initState();
    _loadMore();

    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    print("load more");
    setState(() => isLoading = true);

    try {
      List<Transaction> newItems;

      if (selectedDate != null) {
        final start = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
        );

        final end = start.add(const Duration(days: 1));

        newItems = await _isar.transactions
            .where()
            .dateBetween(start, end)
            .sortByDateDesc()
            .offset(offset)
            .limit(limit)
            .findAll();
      } else {
        newItems = await _isar.transactions
            .where()
            .sortByDateDesc()
            .offset(offset)
            .limit(limit)
            .findAll();
      }

      if (newItems.isEmpty) {
        setState(() {
          isLoading = false;
          hasMore = false;
        });
        return;
      }

      final walletIds = <int>{};
      final cardIds = <int>{};
      final personIds = <int>{};

      for (final t in newItems) {
        switch (t.sourceType) {
          case SourceType.wallet:
            walletIds.add(t.sourceId);
            break;
          case SourceType.creditCard:
            cardIds.add(t.sourceId);
            break;
          case SourceType.person:
            personIds.add(t.sourceId);
            break;
        }
      }

      final wallets = await _isar.wallets.getAll(walletIds.toList());
      final cards = await _isar.creditCards.getAll(cardIds.toList());
      final persons = await _isar.persons.getAll(personIds.toList());

      final walletMap = {for (final w in wallets) w!.id: w.name};
      final cardMap = {for (final c in cards) c!.id: c.name};
      final personMap = {for (final p in persons) p!.id: p.name};

      final enriched = newItems.map((t) {
        String sourceName = "";

        switch (t.sourceType) {
          case SourceType.wallet:
            sourceName = walletMap[t.sourceId] ?? "";
            break;
          case SourceType.creditCard:
            sourceName = cardMap[t.sourceId] ?? "";
            break;
          case SourceType.person:
            sourceName = personMap[t.sourceId] ?? "";
            break;
        }

        return TransactionWithSource(transaction: t, sourceName: sourceName);
      }).toList();

      setState(() {
        offset += newItems.length;
        transactions.addAll(enriched);
        isLoading = false;

        if (newItems.length < limit) {
          hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  void _resetPagination() {
    setState(() {
      transactions.clear();
      offset = 0;
      hasMore = true;
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LynxTheme.background,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: "Transactions"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CustomDatePickerField(
                hint: "Select date to filter",
                includeTime: false,
                showClearButton: true,
                value: selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 31)),
                lastDate: DateTime.now(),
                onChanged: (DateTime? date) {
                  setState(() {
                    selectedDate = date;
                  });

                  _resetPagination();
                  _loadMore();
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: transactions.isEmpty
                    ? Container(
                        height: 120,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedFileEmpty01,
                              size: 42,
                              color: LynxTheme.mutedForeground,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "No transactions found\nfor the selected date.",
                              style: TextStyle(
                                fontSize: 13,
                                color: LynxTheme.mutedForeground,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: _controller,
                        itemCount: transactions.length + (isLoading ? 1 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final transaction = transactions[index].transaction;
                          final source = transactions[index].sourceName;
                          return TransactionCard(
                            transactionFlowType: transaction.flowType,
                            transactionId: transaction.id,
                            transactionType: transaction.type,
                            transactionNote: transaction.note,
                            transactionSource: source,
                            amount: transaction.amount,
                            date: transaction.date,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
