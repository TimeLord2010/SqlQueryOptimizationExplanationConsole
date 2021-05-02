import 'package:console/sql/sintax%20parser/sqlParser.dart';

class WhereStatementUnit {

  String column;
  String op;
  String value;

  WhereStatementUnit (String s) {
    var whereComparatorRegExp = RegExp(whereComparatorPat);
    var match = whereComparatorRegExp.firstMatch(s);
    column = match.namedGroup('whereColumn');
    op = match.namedGroup('whereOperator');
    value = match.namedGroup('whereValue');
  }

}