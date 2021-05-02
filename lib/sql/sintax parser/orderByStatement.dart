import 'package:console/sql/sintax%20parser/sqlParser.dart';

import 'orderByStatementUnit.dart';

class OrderByStatement {

  List<OrderByStatementUnit> statements = [];

  OrderByStatement (String statement) {
    var orderByRegExp = RegExp(orderByUnitPat, caseSensitive: false);
    var matches = orderByRegExp.allMatches(statement);
    for (var match in matches) {
      statements.add(OrderByStatementUnit(match));
    }
  }

}