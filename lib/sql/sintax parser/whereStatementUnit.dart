import 'package:console/sql/sintax%20parser/sqlParser.dart';

class WhereStatementUnit {
  String column;
  String op;
  String value;

  WhereStatementUnit(String s) {
    var v =
        '(?<whereColumn>$singleVarPat)\\s+(?<whereOperator>$whereOperatorPat)\\s+(?<whereValue>$numberPat|$stringValuePat|$singleVarPat)';
    var whereComparatorRegExp = RegExp(v, caseSensitive: false);
    var match = whereComparatorRegExp.firstMatch(s);
    if (match == null) {
      throw Exception(
          'Tried to access groups of non where unit: $s.\nPattern: $v');
    }
    column = match.namedGroup('whereColumn');
    op = match.namedGroup('whereOperator');
    value = match.namedGroup('whereValue');
  }

  Set<String> getTables() {
    var tables = <String>{};
    if (column.contains('.')) {
      var parts = column.split('.');
      tables.add(parts.first);
    }
    var pat = RegExp('^$singleVarPat\$');
    if (pat.hasMatch(value)) {
      if (value.contains('.')) {
        var parts = value.split('.');
        tables.add(parts.first);
      }
    }
    return tables;
  }

  Set<String> getColumns() {
    var columns = <String>{ column };
    var pat = RegExp('^$singleVarPat\$');
    if (pat.hasMatch(value)) {
      columns.add(value);
    }
    return columns;
  }

  Map<String, dynamic> toJson() {
    return {'column': column, 'operator': op, 'value': value};
  }
}
