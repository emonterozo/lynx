import 'package:isar/isar.dart';

import '../../data/models/credit_card.dart';
import '../../data/models/person.dart';
import '../../data/models/transaction.dart';
import '../../data/models/wallet.dart';
import '../enums/app_enums.dart';

class TransactionService {
  final Isar isar;

  TransactionService(this.isar);

  Future<void> apply(Transaction tx) async {
    if (tx.flowType == FlowType.income) {
      final wallet = await isar.wallets.get(tx.sourceId);
      if (wallet == null) return;

      wallet.balance += tx.amount;
      await isar.wallets.put(wallet);
      return;
    }

    if (tx.flowType == FlowType.expense) {
      await _applyExpense(tx);
      return;
    }

    await _applyTransfer(tx);
  }

  Future<void> _applyExpense(Transaction tx) async {
    if (tx.sourceType == SourceType.wallet) {
      final wallet = await isar.wallets.get(tx.sourceId);
      if (wallet == null) return;

      if (wallet.balance < tx.amount) {
        throw Exception("Insufficient balance");
      }

      wallet.balance -= tx.amount;
      await isar.wallets.put(wallet);
    } else if (tx.sourceType == SourceType.creditCard) {
      final card = await isar.creditCards.get(tx.sourceId);
      if (card == null) return;

      card.balance += tx.amount;
      await isar.creditCards.put(card);
    }
  }

  Future<void> _applyTransfer(Transaction tx) async {
    final deduction = tx.amount + tx.fee!;

    if (tx.sourceType == SourceType.wallet) {
      final wallet = await isar.wallets.get(tx.sourceId);
      if (wallet == null) return;

      if (wallet.balance < deduction) {
        throw Exception("Insufficient balance");
      }

      wallet.balance -= deduction;
      await isar.wallets.put(wallet);
    } else if (tx.sourceType == SourceType.creditCard) {
      final card = await isar.creditCards.get(tx.sourceId);
      if (card == null) return;

      card.balance += deduction;
      await isar.creditCards.put(card);
    } else {
      final person = await isar.persons.get(tx.sourceId);
      if (person == null) return;

      person.balance = (person.balance - deduction).clamp(0, double.infinity);
      await isar.persons.put(person);
    }

    if (tx.destinationId == null) return;

    if (tx.destinationType == SourceType.wallet) {
      final wallet = await isar.wallets.get(tx.destinationId!);
      if (wallet == null) return;

      wallet.balance += tx.amount;
      await isar.wallets.put(wallet);
    } else {
      final person = await isar.persons.get(tx.destinationId!);
      if (person == null) return;

      person.balance += tx.amount;
      await isar.persons.put(person);
    }
  }

  Future<void> reverse(Transaction tx) async {
    if (tx.flowType == FlowType.income) {
      final wallet = await isar.wallets.get(tx.sourceId);
      if (wallet == null) return;

      wallet.balance -= tx.amount;
      await isar.wallets.put(wallet);
      return;
    }

    if (tx.flowType == FlowType.expense) {
      if (tx.sourceType == SourceType.wallet) {
        final wallet = await isar.wallets.get(tx.sourceId);
        if (wallet != null) {
          wallet.balance += tx.amount;
          await isar.wallets.put(wallet);
        }
      } else if (tx.sourceType == SourceType.creditCard) {
        final card = await isar.creditCards.get(tx.sourceId);
        if (card != null) {
          card.balance -= tx.amount;
          await isar.creditCards.put(card);
        }
      }

      return;
    }

    final deduction = tx.amount + tx.fee!;

    if (tx.sourceType == SourceType.wallet) {
      final wallet = await isar.wallets.get(tx.sourceId);
      if (wallet != null) {
        wallet.balance += deduction;
        await isar.wallets.put(wallet);
      }
    } else if (tx.sourceType == SourceType.creditCard) {
      final card = await isar.creditCards.get(tx.sourceId);
      if (card != null) {
        card.balance -= deduction;
        await isar.creditCards.put(card);
      }
    } else {
      final person = await isar.persons.get(tx.sourceId);
      if (person != null) {
        person.balance += deduction;
        await isar.persons.put(person);
      }
    }

    if (tx.destinationId == null) return;

    if (tx.destinationType == SourceType.wallet) {
      final wallet = await isar.wallets.get(tx.destinationId!);
      if (wallet != null) {
        wallet.balance -= tx.amount;
        await isar.wallets.put(wallet);
      }
    } else {
      final person = await isar.persons.get(tx.destinationId!);
      if (person != null) {
        person.balance -= tx.amount;
        await isar.persons.put(person);
      }
    }
  }
}
