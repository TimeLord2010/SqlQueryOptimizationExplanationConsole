var singleVarPat = r'[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)?';
var numberPat = r'[0-9]+(\.[0-9]+)?';
var stringValuePat = r"'.*?'";
var whereOperatorPat = r'(=|>|<|<=|>=|<>|like|(not\s+)?in)';
var multipleVarPat = patSeparatedByComma(singleVarPat);
var columnListOrAll = r'(?<columns>(' + multipleVarPat + r'|\*))';
var whereComparatorPat =
    '$singleVarPat\\s+$whereOperatorPat\\s+($numberPat|$stringValuePat|$singleVarPat)';
var whereExpressionPat =
    '$whereComparatorPat(\\s+(and|or)\\s+$whereComparatorPat)*';
var wherePat = '(?<where>\\s+where\\s+$whereExpressionPat)?';
var singleJoinPat = 'join\\s+$singleVarPat\\s+on\\s+$whereExpressionPat';
var nonOptionalJoinPat = '$singleJoinPat(\\s+$singleJoinPat)*';
var joinPat = '(?<join>\\s+$nonOptionalJoinPat)?';
var orderByUnitPat = patSeparatedByComma('$singleVarPat(\\s+(desc|asc))?');
var orderByPat = r'(?<orderby>\s+order\s+by\s+' + orderByUnitPat + r')?';
var sqlPat = RegExp(
    '^select\\s+$columnListOrAll\\s+from\\s+(?<table>$singleVarPat)$joinPat$wherePat$orderByPat\\s*;?\$',
    caseSensitive: false);

String patSeparatedByComma(String pat) {
  return pat + r'(\s*,\s*' + pat + ')*';
}

class JoinStatementUnit {
  String originTable, joinedTable;
  WhereStatement where;
}

class JoinStatement {

  List<JoinStatementUnit> statement;

  JoinStatement (String statement) {

  }

}

class OrderByStatementUnit {
  String column;
  bool asc;
}

class OrderByStatement {

  List<OrderByStatementUnit> statements;

  OrderByStatement (String statement) {

  }

}

class WhereStatement {

  dynamic left;
  bool and;
  dynamic right;

  WhereStatement (String statement) {

  }

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

  SqlParser(String sql) {
    this.sql = sql;
    if (!sqlPat.hasMatch(sql)) throw Exception('Invalid statement $sql.');
    var matches = sqlPat.allMatches(sql);
    if (matches.length != 1) throw Exception('Expected only one match.');
    var match = matches.elementAt(0);
    var columnsGroup = match.namedGroup('columns');
    columnsGroup = columnsGroup.replaceAll(' ', '');
    columns = columnsGroup.split(',');
    var tableGroup = match.namedGroup('table');
    table = tableGroup;
    var joinGroup = match.namedGroup('join');
    join = JoinStatement(joinGroup);
    var whereGroup = match.namedGroup('where');
    where = WhereStatement(whereGroup);
    var orderGroup = match.namedGroup('orderby');
    orderBy = OrderByStatement(orderGroup);
  }
}
