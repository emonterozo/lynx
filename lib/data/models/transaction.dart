import 'package:isar/isar.dart';
import '../../core/enums/app_enums.dart';
import 'credit_card.dart';
import 'wallet.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  late double amount;
  double? fee;

  @Index()
  late DateTime date;

  late String note;

  @Index()
  @Enumerated(EnumType.name)
  late TransactionType type;

  @Enumerated(EnumType.name)
  late FlowType flowType;

  final sourceWallet = IsarLink<Wallet>();
  final destinationWallet = IsarLink<Wallet>();
  final creditCard = IsarLink<CreditCard>();

  Transaction();

  factory Transaction.create({
    required double amount,
    double? fee,
    required DateTime date,
    required String note,
    required TransactionType type,
    required FlowType flowType,
  }) {
    return Transaction()
      ..amount = amount
      ..fee = fee
      ..date = date
      ..note = note
      ..type = type
      ..flowType = flowType;
  }
}
