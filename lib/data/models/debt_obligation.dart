import 'package:isar/isar.dart';
import '../../core/enums/app_enums.dart';

part 'debt_obligation.g.dart';

@collection
class DebtObligation {
  Id id = Isar.autoIncrement;

  int? cardId;

  late String title;
  late double totalAmount;
  late double remainingBalance;
  
  late int totalInstallments;
  late int completedInstallments;
  late double monthlyPayment;
  late DateTime nextDueDate;
  
  @Enumerated(EnumType.name)
  late DebtType type;
  
  late bool isActive;

  DebtObligation();

  factory DebtObligation.create({
    int? cardId,
    required String title,
    required double totalAmount,
    required double remainingBalance,
    required int totalInstallments,
    required int completedInstallments,
    required double monthlyPayment,
    required DateTime nextDueDate,
    required DebtType type,
    required bool isActive,
  }) {
    return DebtObligation()
      ..cardId = cardId
      ..title = title
      ..totalAmount = totalAmount
      ..remainingBalance = remainingBalance
      ..totalInstallments = totalInstallments
      ..completedInstallments = completedInstallments
      ..monthlyPayment = monthlyPayment
      ..nextDueDate = nextDueDate
      ..type = type
      ..isActive = isActive;
  }
}