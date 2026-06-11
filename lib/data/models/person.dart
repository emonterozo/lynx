import 'package:isar/isar.dart';

part 'person.g.dart';

@collection
class Person {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  late double balance;

  late bool showBalance;

  bool isArchived;

  Person({this.isArchived = false});

  Person.create({
    required this.name,
    required this.balance,
    required this.showBalance,
    this.isArchived = false,
  });
}
