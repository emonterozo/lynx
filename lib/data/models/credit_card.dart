import 'package:isar/isar.dart';

part 'credit_card.g.dart';

@collection
class CreditCard {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;
  late double balance;
  late double creditLimit;
  late double statementBalance;
  late bool showBalance;

  late int billingCycleDay;
  late int dueDateDay;

  late String lastFourDigits;

  CreditCard();

  factory CreditCard.create({
    required String name,
    required double balance,
    required double creditLimit,
    required double statementBalance,
    required bool showBalance,

    required int billingCycleDay,
    required int dueDateDay,
    required String lastFourDigits,
  }) {
    return CreditCard()
      ..name = name
      ..balance = balance
      ..creditLimit = creditLimit
      ..statementBalance = statementBalance
      ..showBalance = showBalance
      ..billingCycleDay = billingCycleDay
      ..dueDateDay = dueDateDay
      ..lastFourDigits = lastFourDigits;
  }
}
