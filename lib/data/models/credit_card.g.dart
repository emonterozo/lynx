// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCreditCardCollection on Isar {
  IsarCollection<CreditCard> get creditCards => this.collection();
}

const CreditCardSchema = CollectionSchema(
  name: r'CreditCard',
  id: 687928797046475984,
  properties: {
    r'balance': PropertySchema(
      id: 0,
      name: r'balance',
      type: IsarType.double,
    ),
    r'billingCycleDay': PropertySchema(
      id: 1,
      name: r'billingCycleDay',
      type: IsarType.long,
    ),
    r'lastFourDigits': PropertySchema(
      id: 2,
      name: r'lastFourDigits',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'showBalance': PropertySchema(
      id: 4,
      name: r'showBalance',
      type: IsarType.bool,
    ),
    r'statementBalance': PropertySchema(
      id: 5,
      name: r'statementBalance',
      type: IsarType.double,
    )
  },
  estimateSize: _creditCardEstimateSize,
  serialize: _creditCardSerialize,
  deserialize: _creditCardDeserialize,
  deserializeProp: _creditCardDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _creditCardGetId,
  getLinks: _creditCardGetLinks,
  attach: _creditCardAttach,
  version: '3.1.0+1',
);

int _creditCardEstimateSize(
  CreditCard object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.lastFourDigits.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _creditCardSerialize(
  CreditCard object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.balance);
  writer.writeLong(offsets[1], object.billingCycleDay);
  writer.writeString(offsets[2], object.lastFourDigits);
  writer.writeString(offsets[3], object.name);
  writer.writeBool(offsets[4], object.showBalance);
  writer.writeDouble(offsets[5], object.statementBalance);
}

CreditCard _creditCardDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CreditCard();
  object.balance = reader.readDouble(offsets[0]);
  object.billingCycleDay = reader.readLong(offsets[1]);
  object.id = id;
  object.lastFourDigits = reader.readString(offsets[2]);
  object.name = reader.readString(offsets[3]);
  object.showBalance = reader.readBool(offsets[4]);
  object.statementBalance = reader.readDouble(offsets[5]);
  return object;
}

P _creditCardDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _creditCardGetId(CreditCard object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _creditCardGetLinks(CreditCard object) {
  return [];
}

void _creditCardAttach(IsarCollection<dynamic> col, Id id, CreditCard object) {
  object.id = id;
}

extension CreditCardQueryWhereSort
    on QueryBuilder<CreditCard, CreditCard, QWhere> {
  QueryBuilder<CreditCard, CreditCard, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }
}

extension CreditCardQueryWhere
    on QueryBuilder<CreditCard, CreditCard, QWhereClause> {
  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> nameEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> nameNotEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> nameGreaterThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [name],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> nameLessThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [],
        upper: [name],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> nameBetween(
    String lowerName,
    String upperName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [lowerName],
        includeLower: includeLower,
        upper: [upperName],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> nameStartsWith(
      String NamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [NamePrefix],
        upper: ['$NamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [''],
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'name',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'name',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'name',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'name',
              upper: [''],
            ));
      }
    });
  }
}

extension CreditCardQueryFilter
    on QueryBuilder<CreditCard, CreditCard, QFilterCondition> {
  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> balanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      balanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> balanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> balanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'balance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      billingCycleDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'billingCycleDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      billingCycleDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'billingCycleDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      billingCycleDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'billingCycleDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      billingCycleDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'billingCycleDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      lastFourDigitsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFourDigits',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      lastFourDigitsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastFourDigits',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      lastFourDigitsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastFourDigits',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      lastFourDigitsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastFourDigits',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      lastFourDigitsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastFourDigits',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      lastFourDigitsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastFourDigits',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      lastFourDigitsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastFourDigits',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      lastFourDigitsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastFourDigits',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      lastFourDigitsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFourDigits',
        value: '',
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      lastFourDigitsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastFourDigits',
        value: '',
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      showBalanceEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      statementBalanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statementBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      statementBalanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statementBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      statementBalanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statementBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      statementBalanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statementBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension CreditCardQueryObject
    on QueryBuilder<CreditCard, CreditCard, QFilterCondition> {}

extension CreditCardQueryLinks
    on QueryBuilder<CreditCard, CreditCard, QFilterCondition> {}

extension CreditCardQuerySortBy
    on QueryBuilder<CreditCard, CreditCard, QSortBy> {
  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByBillingCycleDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billingCycleDay', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy>
      sortByBillingCycleDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billingCycleDay', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByLastFourDigits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFourDigits', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy>
      sortByLastFourDigitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFourDigits', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByShowBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBalance', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByShowBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBalance', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByStatementBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statementBalance', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy>
      sortByStatementBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statementBalance', Sort.desc);
    });
  }
}

extension CreditCardQuerySortThenBy
    on QueryBuilder<CreditCard, CreditCard, QSortThenBy> {
  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByBillingCycleDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billingCycleDay', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy>
      thenByBillingCycleDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billingCycleDay', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByLastFourDigits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFourDigits', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy>
      thenByLastFourDigitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFourDigits', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByShowBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBalance', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByShowBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBalance', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByStatementBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statementBalance', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy>
      thenByStatementBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statementBalance', Sort.desc);
    });
  }
}

extension CreditCardQueryWhereDistinct
    on QueryBuilder<CreditCard, CreditCard, QDistinct> {
  QueryBuilder<CreditCard, CreditCard, QDistinct> distinctByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balance');
    });
  }

  QueryBuilder<CreditCard, CreditCard, QDistinct> distinctByBillingCycleDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'billingCycleDay');
    });
  }

  QueryBuilder<CreditCard, CreditCard, QDistinct> distinctByLastFourDigits(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFourDigits',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QDistinct> distinctByShowBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showBalance');
    });
  }

  QueryBuilder<CreditCard, CreditCard, QDistinct> distinctByStatementBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statementBalance');
    });
  }
}

extension CreditCardQueryProperty
    on QueryBuilder<CreditCard, CreditCard, QQueryProperty> {
  QueryBuilder<CreditCard, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CreditCard, double, QQueryOperations> balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balance');
    });
  }

  QueryBuilder<CreditCard, int, QQueryOperations> billingCycleDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'billingCycleDay');
    });
  }

  QueryBuilder<CreditCard, String, QQueryOperations> lastFourDigitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFourDigits');
    });
  }

  QueryBuilder<CreditCard, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CreditCard, bool, QQueryOperations> showBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showBalance');
    });
  }

  QueryBuilder<CreditCard, double, QQueryOperations>
      statementBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statementBalance');
    });
  }
}
