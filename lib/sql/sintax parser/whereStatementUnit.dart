import 'package:console/sql/sintax%20parser/sqlParser.dart';

class WhereStatementUnit {

  String column;
  String op;
  String value;

  WhereStatementUnit (String s) {
    var v = '(?<whereColumn>$singleVarPat)\\s+(?<whereOperator>$whereOperatorPat)\\s+(?<whereValue>$numberPat|$stringValuePat|$singleVarPat)';
    var whereComparatorRegExp = RegExp(v, caseSensitive: false);
    var match = whereComparatorRegExp.firstMatch(s);
    if (match == null) {
      
      throw Exception('Tried to access groups of non where unit: $s.\nPattern: $v');
    }
    column = match.namedGroup('whereColumn');
    op = match.namedGroup('whereOperator');
    value = match.namedGroup('whereValue');
  }

  Map<String, dynamic> toJson () {
    return {
      'column': column,
      'operator': op,
      'value': value
    };
  }

}