import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:lynx/data/models/budget.dart';
import 'package:lynx/data/models/person.dart';
import 'package:lynx/screens/budget.dart';
import 'package:lynx/screens/credit_card_form.dart';
import 'package:lynx/screens/transactions.dart';
import 'package:lynx/screens/wallet_form.dart';
import '../core/enums/app_enums.dart';
import '../core/theme.dart';
import '../core/utils/number_utils.dart';
import '../data/models/credit_card.dart';
import '../data/models/transaction.dart';
import '../data/models/wallet.dart';
import '../presentation/models/transaction_with_source.dart';
import '../widgets/transaction_card.dart';
import '../widgets/wallet_card.dart';
import 'budget_form.dart';

final DateFormat dateFormat = DateFormat('EEE, MMM dd');

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final Isar _isar = Isar.getInstance()!;

  void _navigateToWalletForm() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => WalletForm()));
  }

  void _navigateToCreditCardForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreditCardForm()),
    );
  }

  void _navigateToBudgetForm() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetForm()));
  }

  Future<String> getSourceName(SourceType type, int id) async {
    switch (type) {
      case SourceType.wallet:
        final wallet = await _isar.wallets.get(id);
        return wallet?.name ?? "";

      case SourceType.creditCard:
        final card = await _isar.creditCards.get(id);
        return card?.name ?? "";

      case SourceType.person:
        final person = await _isar.persons.get(id);
        return person?.name ?? "";
    }
  }

  Future<List<TransactionWithSource>> _loadTransactionLinks(
    List<Transaction> transactions,
  ) async {
    return Future.wait(
      transactions.map((t) async {
        final sourceName = await getSourceName(t.sourceType, t.sourceId);

        return TransactionWithSource(transaction: t, sourceName: sourceName);
      }),
    );
  }

  Future<void> _runBillingCheck() async {
    final now = DateTime.now();

    final cards = await _isar.creditCards.where().findAll();

    await _isar.writeTxn(() async {
      for (final card in cards) {
        if (card.billingCycleDay == now.day) {
          //will get installment details
          card.statementBalance = card.balance;
          await _isar.creditCards.put(card);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _runBillingCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LynxTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<List<Wallet>>(
                stream: _isar.wallets.where().sortByBalance().watch(
                  fireImmediately: true,
                ),
                builder: (context, snapshot) {
                  final wallets = snapshot.data ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        title: "My Wallets",
                        showViewAll: wallets.length > 4,
                      ),
                      const SizedBox(height: 12),
                      wallets.isEmpty
                          ? Container(
                              height: 120,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const HugeIcon(
                                    icon: HugeIcons.strokeRoundedFileEmpty01,
                                    size: 32,
                                    color: LynxTheme.mutedForeground,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "No wallets found",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: LynxTheme.mutedForeground,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _navigateToWalletForm,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        "Add Wallet",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: LynxTheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _horizontalList(
                              isWallet: true,
                              itemCount: wallets.length,
                              itemBuilder: (index) => WalletCard(
                                account: wallets[index],
                                onTap: () {},
                              ),
                            ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              StreamBuilder<List<CreditCard>>(
                stream: _isar.creditCards.where().sortByBalanceDesc().watch(
                  fireImmediately: true,
                ),
                builder: (context, snapshot) {
                  final creditCards = snapshot.data ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        title: "My Credit Cards",
                        showViewAll: creditCards.length > 4,
                      ),
                      const SizedBox(height: 12),
                      creditCards.isEmpty
                          ? Container(
                              height: 120,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const HugeIcon(
                                    icon: HugeIcons.strokeRoundedFileEmpty01,
                                    size: 32,
                                    color: LynxTheme.mutedForeground,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "No credit cards found",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: LynxTheme.mutedForeground,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _navigateToCreditCardForm,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        "Add Credit Card",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: LynxTheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _horizontalList(
                              isWallet: false,
                              itemCount: creditCards.length,
                              itemBuilder: (index) => WalletCard(
                                account: creditCards[index],
                                onTap: () {},
                              ),
                            ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              StreamBuilder<List<Transaction>>(
                stream: _isar.transactions.where().watch(fireImmediately: true),
                builder: (context, transactionSnapshot) {
                  final transactions = transactionSnapshot.data ?? [];
                  return StreamBuilder<List<Budget>>(
                    stream: _isar.budgets.where().watch(fireImmediately: true),
                    builder: (context, snapshot) {
                      final budgets = snapshot.data ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
                            title: "My Budgets",
                            showViewAll: budgets.length > 4,
                          ),
                          const SizedBox(height: 12),
                          budgets.isEmpty
                              ? Container(
                                  height: 120,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const HugeIcon(
                                        icon:
                                            HugeIcons.strokeRoundedFileEmpty01,
                                        size: 32,
                                        color: LynxTheme.mutedForeground,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "No budgets found",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: LynxTheme.mutedForeground,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _navigateToBudgetForm,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4.0,
                                          ),
                                          child: Text(
                                            "Add Budget",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: LynxTheme.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : _budgetList(
                                  itemCount: budgets.length,
                                  itemBuilder: (index) => _buildBudgetCard(
                                    budgets[index],
                                    transactions,
                                  ),
                                ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
              StreamBuilder<List<Transaction>>(
                stream: _isar.transactions.where().sortByDateDesc().watch(
                  fireImmediately: true,
                ),
                builder: (context, snapshot) {
                  final allTransactions = snapshot.data ?? [];

                  return FutureBuilder<List<TransactionWithSource>>(
                    future: _loadTransactionLinks(allTransactions),
                    builder: (context, linkSnapshot) {
                      if (linkSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final loadedTransactions = linkSnapshot.data ?? [];
                      final totalCount = loadedTransactions.length;
                      final transactions = loadedTransactions.take(5).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
                            title: "Recent Transactions",
                            showViewAll: totalCount > 4,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Transactions(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          transactions.isEmpty
                              ? Container(
                                  height: 120,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const HugeIcon(
                                        icon:
                                            HugeIcons.strokeRoundedFileEmpty01,
                                        size: 42,
                                        color: LynxTheme.mutedForeground,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "You don't have any\ntransactions yet.",
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
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: transactions.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (_, index) {
                                    final transaction =
                                        transactions[index].transaction;
                                    final source =
                                        transactions[index].sourceName;
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
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    bool showViewAll = false,
    VoidCallback? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (showViewAll)
          GestureDetector(
            onTap: onTap,
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: LynxTheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _horizontalList({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
    required bool isWallet,
  }) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) => index == 0
            ? _addButton(isWallet: isWallet)
            : itemBuilder(index - 1),
      ),
    );
  }

  Widget _budgetList({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
  }) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) =>
            index == 0 ? _buildBudgetAddButton() : itemBuilder(index - 1),
      ),
    );
  }

  Widget _budgetLayout({
    required Widget icon,
    required String label,
    required String subLabel,
    double? progress,
    bool isAddButton = false,
  }) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          GestureDetector(
            onTap: isAddButton
                ? _navigateToBudgetForm
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BudgetScreen()),
                    );
                  },
            child: SizedBox(
              height: 70,
              width: 70,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!isAddButton)
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: LynxTheme.border.withValues(alpha: 0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          strokeCap: StrokeCap.round,
                          color: LynxTheme.primary,
                          backgroundColor: LynxTheme.border.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ),

                  if (isAddButton)
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: LynxTheme.border.withValues(alpha: 0.3),
                      ),
                    ),
                  icon,
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subLabel,
            style: isAddButton
                ? const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)
                : const TextStyle(
                    fontSize: 12,
                    color: LynxTheme.mutedForeground,
                  ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(Budget budget, List<Transaction> allTransactions) {
    final double consumed = budget.calculateConsumed(allTransactions);
    final double remaining = budget.limitAmount - consumed;

    final double progress = budget.limitAmount > 0
        ? (consumed / budget.limitAmount).clamp(0.0, 1.0)
        : 0.0;

    String subLabel;
    if (remaining < 0) {
      subLabel =
          "Over budget by ₱${NumberUtils.currencyFormatter(remaining.abs())}";
    } else {
      subLabel = "₱${NumberUtils.currencyFormatter(remaining)} left";
    }

    return _budgetLayout(
      icon: HugeIcon(
        icon: budget.type.icon,
        size: 34,
        color: LynxTheme.primary,
      ),
      label: budget.name,
      subLabel: subLabel,
      progress: progress,
    );
  }

  Widget _buildBudgetAddButton() => _budgetLayout(
    icon: const HugeIcon(
      icon: HugeIcons.strokeRoundedAdd01,
      size: 34,
      color: LynxTheme.primary,
    ),
    label: "Add",
    subLabel: "Budget",
    isAddButton: true,
  );

  Widget _addButton({required bool isWallet}) => GestureDetector(
    onTap: isWallet ? _navigateToWalletForm : _navigateToCreditCardForm,
    child: Container(
      width: 60,
      decoration: BoxDecoration(
        color: LynxTheme.border.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedAdd01,
          size: 34,
          color: LynxTheme.primary,
        ),
      ),
    ),
  );
}
