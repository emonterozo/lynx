import 'package:isar/isar.dart';
import '../../core/enums/app_enums.dart';

part 'wallet.g.dart';

@collection
class Wallet {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  late double balance;

  late bool showBalance;

  @enumerated
  late WalletType type;

  DateTime? startDate;
  DateTime? endDate;

  double? goalAmount;

  bool isArchived;

  Wallet({this.isArchived = false});

  Wallet.create({
    required this.name,
    required this.balance,
    required this.showBalance,
    required this.type,
    this.startDate,
    this.endDate,
    this.goalAmount,
    this.isArchived = false,
  });

  bool get isLiquidated => balance == 0 || isArchived;

  double get timeProgress {
    if (startDate == null || endDate == null) return 0.0;

    final totalDuration = endDate!.difference(startDate!).inDays;
    if (totalDuration <= 0) return 1.0;

    final elapsed = DateTime.now().difference(startDate!).inDays;
    return (elapsed / totalDuration).clamp(0.0, 1.0);
  }

  double get financialProgress {
    if (goalAmount != null && goalAmount! > 0) {
      return (balance / goalAmount!).clamp(0.0, 1.0);
    }
    return 0.0;
  }

  double get progress {
    switch (type) {
      case WalletType.timeDeposit:
        return timeProgress;
      case WalletType.goals:
        return financialProgress;
      default:
        return 0.0;
    }
  }
}
