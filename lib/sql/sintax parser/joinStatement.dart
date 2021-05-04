import 'package:console/sql/sintax%20parser/sqlParser.dart';

import 'joinStatementUnit.dart';

class JoinStatement {

  List<JoinStatementUnit> statement = [];

  JoinStatement (String s) {
    var singleJoinRegExp = RegExp('join\\s+(?<joinTable>$singleVarPat)\\s+on\\s+(?<joinCondition>$whereExpressionPat)', caseSensitive: false);
    var matches = singleJoinRegExp.allMatches(s);
    for (var match in matches) {
      statement.add(JoinStatementUnit(match));
    }
  }

  List<Map<String, dynamic>> toJson() {
    return statement.map((e) => e.toJson()).toList();
  }

}