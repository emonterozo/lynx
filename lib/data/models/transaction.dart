import 'package:isar/isar.dart';
import '../../core/enums/app_enums.dart';
import '../../presentation/models/source_item.dart';

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

  late int sourceId;

  @Enumerated(EnumType.name)
  late SourceType sourceType;

  int? destinationId;

  @Enumerated(EnumType.name)
  SourceType? destinationType;

  Transaction();

  Transaction.create({
    required this.amount,
    this.fee,
    required this.date,
    required this.note,
    required this.type,
    required this.flowType,
    required this.sourceId,
    required SourceItem source,
    SourceItem? destination,
    this.destinationId,
  }) {
    sourceId = source.id;
    sourceType = source.type;

    if (destination != null) {
      destinationId = destination.id;
      destinationType = destination.type;
    }
  }
}
