import 'package:isar/isar.dart';
import '../../core/enums/app_enums.dart';
import 'transaction.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;
  late String name;
  late double limitAmount;
  late DateTime startDate;

  @Enumerated(EnumType.name)
  late CycleType cycleType;

  @Enumerated(EnumType.name)
  late TransactionType type;

  DateTime _addCycle(DateTime fromDate) {
    switch (cycleType) {
      case CycleType.weekly:
        return fromDate.add(const Duration(days: 7));
      case CycleType.monthly:
        return DateTime(fromDate.year, fromDate.month + 1, fromDate.day);
    }
  }

  DateTime getActiveCycleStart({DateTime? mockNow}) {
    final now = mockNow ?? DateTime.now();
    DateTime cycleStart = startDate;

    while (_addCycle(cycleStart).isBefore(now) ||
        _addCycle(cycleStart).isAtSameMomentAs(now)) {
      cycleStart = _addCycle(cycleStart);
    }
    return cycleStart;
  }

  DateTime getActiveCycleEnd({DateTime? mockNow}) =>
      _addCycle(getActiveCycleStart(mockNow: mockNow));

  double calculateConsumed(
    List<Transaction> allTransactions, {
    DateTime? mockNow,
  }) {
    final start = getActiveCycleStart(mockNow: mockNow);
    final end = getActiveCycleEnd(mockNow: mockNow);

    return allTransactions
        .where((t) => t.type == type)
        .where((t) => !t.date.isBefore(start) && t.date.isBefore(end))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double calculateRemaining(
    List<Transaction> allTransactions, {
    DateTime? mockNow,
  }) => limitAmount - calculateConsumed(allTransactions, mockNow: mockNow);
}
