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
  final sourceCreditCard = IsarLink<CreditCard>();
  final destinationWallet = IsarLink<Wallet>();

  Transaction();

  Transaction.create({
    required this.amount,
    this.fee,
    required this.date,
    required this.note,
    required this.type,
    required this.flowType,
    Wallet? sourceWallet,
    CreditCard? sourceCreditCard,
    Wallet? destinationWallet,
  }) {
    if (sourceWallet != null) {
      this.sourceWallet.value = sourceWallet;
    }

    if (sourceCreditCard != null) {
      this.sourceCreditCard.value = sourceCreditCard;
    }

    if (destinationWallet != null) {
      this.destinationWallet.value = destinationWallet;
    }
  }
}
