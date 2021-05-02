class WhereStatement {

  dynamic left;
  bool and;
  dynamic right;

  WhereStatement (String statement) {
    var parts = splitOnce(statement, RegExp('and', caseSensitive: false));
    if (parts.length == 2) {
      left = WhereStatement(parts[0]);
      and = true;
      right = WhereStatement(parts[1]);
      return;
    }
    parts = splitOnce(statement, RegExp('or', caseSensitive: false))
    if (parts.length == 2) {
      left = WhereStatement(parts[0]);
      and = false;
      right = WhereStatement(parts[1]);
      return;
    }
    left = WhereStatementUnit(statement);
    and = null;
  }

}