import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:lynx/data/models/budget.dart';
import '../core/enums/app_enums.dart';
import '../core/theme.dart';
import '../data/models/credit_card.dart';
import '../data/models/transaction.dart';
import '../data/models/wallet.dart';
import '../widgets/wallet_card.dart';

final currencyFormatter = NumberFormat("#,##0.00", "en_PH");
final DateFormat dateFormat = DateFormat('MMM dd, hh:mm a');

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final Isar _isar = Isar.getInstance()!;

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
                stream: _isar.wallets.where().watch(fireImmediately: true),
                builder: (context, snapshot) {
                  final wallets = snapshot.data ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        "My Wallets",
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
                                    "No wallets found.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: LynxTheme.mutedForeground,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
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
                stream: _isar.creditCards.where().watch(fireImmediately: true),
                builder: (context, snapshot) {
                  final creditCards = snapshot.data ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        "My Credit Cards",
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
                                    "No credit cards found.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: LynxTheme.mutedForeground,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
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
                            "My Budgets",
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
                                        "No budgets found.",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: LynxTheme.mutedForeground,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
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
                stream: _isar.transactions.where().watch(fireImmediately: true),
                builder: (context, snapshot) {
                  final transactions = snapshot.data ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        "Recent Transactions",
                        showViewAll: transactions.length > 4,
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
                                    icon: HugeIcons.strokeRoundedFileEmpty01,
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
                              itemBuilder: (_, index) =>
                                  _transactionItem(transactions[index]),
                            ),
                    ],
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

  Widget _sectionHeader(String title, {bool showViewAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (showViewAll)
          GestureDetector(
            onTap: () {},
            child: const Text(
              "View All",
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
    double height = 120,
  }) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) =>
            index == 0 ? _buildAddButton() : itemBuilder(index - 1),
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
          SizedBox(
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
      subLabel = "Over budget by ₱${currencyFormatter.format(remaining.abs())}";
    } else {
      subLabel = "₱${currencyFormatter.format(remaining)} left";
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

  Widget _transactionItem(Transaction transaction) {
    final isExpense = transaction.flowType == FlowType.expense;
    final sign = isExpense ? "-" : "+";
    final color = isExpense ? LynxTheme.error : LynxTheme.success;

    final formattedDate = dateFormat.format(transaction.date);

    final formattedAmount =
        "$sign₱${currencyFormatter.format(transaction.amount)}";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LynxTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          HugeIcon(icon: transaction.type.icon, color: LynxTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.note,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: LynxTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formattedAmount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color, // Dynamic color: Red for expense, Green for income
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() => Container(
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
  );
}
