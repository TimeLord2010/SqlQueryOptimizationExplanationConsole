class JoinStatementUnit {

  String joinedTable;
  WhereStatement where;

  JoinStatementUnit (RegExpMatch match) {
    joinedTable = match.namedGroup('joinTable');
    where = WhereStatement(match.namedGroup('joinCondition'));
  }

}