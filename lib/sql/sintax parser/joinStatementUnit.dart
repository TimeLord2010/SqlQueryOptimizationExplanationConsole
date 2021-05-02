import 'package:console/sql/sintax%20parser/whereStatement.dart';

class JoinStatementUnit {

  String joinedTable;
  WhereStatement where;

  JoinStatementUnit (RegExpMatch match) {
    joinedTable = match.namedGroup('joinTable');
    where = WhereStatement(match.namedGroup('joinCondition'));
  }

}