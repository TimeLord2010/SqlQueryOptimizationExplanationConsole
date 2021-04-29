int calculate() {
  return 6 * 7;
}

class JoinStatementUnit {
  String originTable, joinedTable;
  WhereStatement where;
}

class JoinStatement {
  List<JoinStatementUnit> statement;
}

class OrderByStatementUnit {
  String column;
  bool asc;
}

class OrderByStatement {
  List<OrderByStatementUnit> statements;
}

class WhereStatement {
  dynamic left;
}

class FullWhereStatement extends WhereStatement {
  bool and;
  dynamic right;
}

class WhereStatementUnit {
  String column;
  String op;
  String value;
}

class SqlParser {

  String sql;

  List<String> columns;
  String table;
  JoinStatement join;
  WhereStatement where;
  OrderByStatement orderBy;

  SqlParser (String sql) {
    this.sql = sql;
  }

}