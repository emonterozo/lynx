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

  Wallet();

  Wallet.create({
    required this.name,
    required this.balance,
    required this.showBalance,
    required this.type,
  });
}
