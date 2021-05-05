import 'package:console/sql/sintax%20parser/sqlParser.dart';

import 'joinStatementUnit.dart';

class JoinStatement {

  List<JoinStatementUnit> statement = [];

  JoinStatement(String s) {
    var singleJoinRegExp = RegExp(
        'join\\s+(?<joinTable>$singleVarPat)\\s+on\\s+(?<joinCondition>$whereExpressionPat)',
        caseSensitive: false);
    var matches = singleJoinRegExp.allMatches(s);
    for (var match in matches) {
      statement.add(JoinStatementUnit(match));
    }
  }

  Set<String> getTables() {
    var tables = <String>{};
    for (var joinUnit in statement) {
      tables.add(joinUnit.joinedTable);
      tables.addAll(joinUnit.where.getTables());
    }
    return tables;
  }

  Set<String> getColumns () {
    var columns = <String>{};
    for (var unit in statement) {
      columns.addAll(unit.where.getColumns());
    }
    return columns;
  }

  List<Map<String, dynamic>> toJson() {
    return statement.map((e) => e.toJson()).toList();
  }
}
