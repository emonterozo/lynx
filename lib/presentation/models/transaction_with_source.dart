import '../../data/models/transaction.dart';

class TransactionWithSource {
  final Transaction transaction;
  final String sourceName;

  TransactionWithSource({required this.transaction, required this.sourceName});
}
