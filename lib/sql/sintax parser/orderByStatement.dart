import 'package:console/sql/sintax%20parser/sqlParser.dart';

import 'orderByStatementUnit.dart';

class OrderByStatement {

  List<OrderByStatementUnit> statements = [];

  OrderByStatement (String statement) {
    var orderByRegExp = RegExp('(?<orderByColumn>$singleVarPat)(\\s+(?<orderBySort>desc|asc))', caseSensitive: false);
    var matches = orderByRegExp.allMatches(statement);
    for (var match in matches) {
      statements.add(OrderByStatementUnit(match));
    }
  }

  List<Map<String, dynamic>> toJson() {
    return statements.map((e) => e.toJson()).toList();
  }

  Set<String> getTables() {
    var tables = <String>{};
    for (var unit in statements) {
      tables.add(unit.getTable());
    }
    return tables;
  }

  Set<String> getColumns () {
    var columns = <String>{};
    for (var unit in statements) {
      columns.add(unit.column);
    }
    return columns;
  }

}