import 'package:hugeicons/hugeicons.dart';

enum AppState { loading, loaded, error, initialize }

enum WalletType {
  general('general', 'General', HugeIcons.strokeRoundedMoney01),
  cash('cash', 'Cash', HugeIcons.strokeRoundedHandCoins),
  bank('bank', 'Bank', HugeIcons.strokeRoundedLandmark),
  ewallet('e-wallet', 'E-Wallet', HugeIcons.strokeRoundedWallet01),
  savings('savings', 'Savings', HugeIcons.strokeRoundedPiggyBank),
  goals('goals', 'Goals', HugeIcons.strokeRoundedTarget02),
  timeDeposit(
    'time-deposit',
    'Time Deposit',
    HugeIcons.strokeRoundedTimeQuarter02,
  );

  final String value;
  final String label;
  final List<List<dynamic>> icon;

  const WalletType(this.value, this.label, this.icon);

  static WalletType fromString(String value) {
    return WalletType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WalletType.general,
    );
  }
}

enum DebtType {
  installment(
    'installment',
    'Installment',
    HugeIcons.strokeRoundedShoppingBag02,
  ),
  creditToCash(
    'credit-to-cash',
    'Credit to Cash',
    HugeIcons.strokeRoundedMoneyReceive01,
  ),
  personalLoan('personal-loan', 'Personal Loan', HugeIcons.strokeRoundedNote03);

  final String value;
  final String label;
  final List<List<dynamic>> icon;

  const DebtType(this.value, this.label, this.icon);

  static DebtType fromString(String value) {
    return DebtType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DebtType.installment,
    );
  }
}

enum TransactionType {
  salary('salary', 'Salary', HugeIcons.strokeRoundedWalletAdd01),
  transfer(
    'transfer',
    'Transfer',
    HugeIcons.strokeRoundedArrowDataTransferDiagonal,
  ),
  interestEarned(
    'interest-earned',
    'Interest Earned',
    HugeIcons.strokeRoundedMoneyAdd01,
  ),
  housing('housing', 'Housing', HugeIcons.strokeRoundedHome01),
  utilities('utilities', 'Utilities', HugeIcons.strokeRoundedInvoice01),
  groceries('groceries', 'Groceries', HugeIcons.strokeRoundedShoppingBasket01),
  transport('transport', 'Transportation', HugeIcons.strokeRoundedBus01),
  food('food', 'Food', HugeIcons.strokeRoundedMilkCarton),
  entertainment(
    'entertainment',
    'Entertainment',
    HugeIcons.strokeRoundedPopcorn,
  ),
  shopping('shopping', 'Shopping', HugeIcons.strokeRoundedShoppingBag01),
  debt('debt', 'Debt Payment', HugeIcons.strokeRoundedCreditCard),
  savings('savings', 'Savings/Investment', HugeIcons.strokeRoundedPiggyBank),
  others('others', 'Others', HugeIcons.strokeRoundedClipboard);

  final String value;
  final String label;
  final List<List<dynamic>> icon;

  const TransactionType(this.value, this.label, this.icon);

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TransactionType.others,
    );
  }
}

enum CycleType {
  weekly('weekly', 'Weekly', HugeIcons.strokeRoundedCalendar04),
  monthly('monthly', 'Monthly', HugeIcons.strokeRoundedCalendar02);

  final String value;
  final String label;
  final List<List<dynamic>> icon;

  const CycleType(this.value, this.label, this.icon);

  static CycleType fromString(String value) {
    return CycleType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CycleType.monthly,
    );
  }
}

enum FlowType {
  income('income', 'Income', HugeIcons.strokeRoundedWalletAdd01),
  expense('expense', 'Expense', HugeIcons.strokeRoundedWallet03),
  transfer(
    'transfer',
    'Transfer',
    HugeIcons.strokeRoundedArrowDataTransferDiagonal,
  );

  final String value;
  final String label;
  final List<List<dynamic>> icon;

  const FlowType(this.value, this.label, this.icon);

  static FlowType fromString(String value) {
    return FlowType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => FlowType.expense,
    );
  }
}

enum SourceType { wallet, creditCard, person }
