import 'package:console/console.dart' as console;
import 'package:console/stringUtil.dart';

var singleVarPat = r'[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)?';
var numberPat = r'[0-9]+(\.[0-9]+)?';
var stringValuePat = r"'.*?'";
var whereOperatorPat = r'(=|>|<|<=|>=|<>|like|(not\s+)?in)';
var multipleVarPat = patSeparatedByComma(singleVarPat);
var columnListOrAll = r'(?<columns>(' + multipleVarPat + r'|\*))';
var whereComparatorPat = '$singleVarPat\\s+$whereOperatorPat\\s+($numberPat|$stringValuePat|$singleVarPat)';
var whereExpressionPat = '$whereComparatorPat(\\s+(and|or)\\s+$whereComparatorPat)*';
var wherePat = '(?<where>\\s+where\\s+$whereExpressionPat)?';

bool isWhere(String txt) {
  txt = txt.trim();
  if (txt.contains(RegExp(r'\sand\s'))) {
    var parts = splitOnce(txt, RegExp(r'\sand\s'));
    var result1 = isWhere(parts[0]);
    var result2 = isWhere(parts[1]);
    return result1 && result2;
  }
  if (txt.contains(RegExp(r'\sor\s'))) {
    var parts = splitOnce(txt, RegExp(r'\sor\s'));
    var result1 = isWhere(parts[0]);
    var result2 = isWhere(parts[1]);
    return result1 && result2;
  }
  var likePat = RegExp("^$singleVarPat\s+like\s+'.*'\$");
  if (likePat.hasMatch(txt)) return true;
  var strValue = "'.*'";
  strValue = patSeparatedByComma(strValue);
  var inPat = RegExp('^$singleVarPat\s+(not)?\s+in\s+\($strValue\)\$');
  if (inPat.hasMatch(txt)) return true;
  var strOper = '=|<>';
  var strComparatorPat = RegExp("^$singleVarPat\s+$strOper\s+'.*'\$");
  if (strComparatorPat.hasMatch(txt)) return true;
  var numOper = '=|>|<|<=|>=|<>';
  var numComparatorPat = RegExp('^$singleVarPat\s+$numOper\s+[0-9]+\$');
  if (numComparatorPat.hasMatch(numOper)) return true;
  return false;
}

String patSeparatedByComma(String pat) {
  return pat + r'(\s*,\s*' + pat + ')*';
  //return pat + r'\s*(,\s*' + pat + ')*';
}

void testWhereStatements (List<String> statements) {
  //var _wherePat = wherePat;
  //var _wherePat = '(' + wherePat.substring(12);
  var _wherePat = '(?<where>' + wherePat.substring(12);
  //var _wherePat = wherePat.substring(12, wherePat.length - 2);
  _wherePat = '^$_wherePat\$';
  print('where pattern: $_wherePat');
  var wherePattern = RegExp(_wherePat, caseSensitive: false);
  for (var st in statements) {
    print('statement: $st');
    var hasWhere = wherePattern.hasMatch(st);
    print('has where: $hasWhere');
    var matches = wherePattern.allMatches(st);
    for (var match in matches) {
      print('start: ' + match.start.toString() + ' end: ' + match.end.toString());
      var value = st.substring(match.start, match.end);
      print('match: $value');
      // print('group count: ' + match.groupCount.toString());
      // for (var i = 0; i < match.groupCount; i++) {
      //   print('group[$i]: ' + match.group(i));
      // }
    }
    print('');
  }
}

void testStatements(List<String> statements) {
  print('where pat: $wherePat\n');
  var singleJoinPat = 'join\\s+$singleVarPat\\s+on\\s+$whereExpressionPat';
  var nonOptionalJoinPat = '$singleJoinPat(\\s+$singleJoinPat)*';
  var joinPat = '(?<join>\\s+$nonOptionalJoinPat)?';
  var joinPatValue = joinPat.toString();
  print('join pat: $joinPatValue\n');
  var orderByUnitPat = '$singleVarPat(\\s+(desc|asc))?';
  orderByUnitPat = patSeparatedByComma(orderByUnitPat);
  var orderByPat = r'(?<orderby>\s+order\s+by\s+' + orderByUnitPat + r')?';
  var orderByPatValue = orderByPat.toString();
  print('order by pat: $orderByPatValue\n');
  var pat = RegExp(
      '^select\\s+$columnListOrAll\\s+from\\s+(?<table>$singleVarPat)$joinPat$wherePat$orderByPat\\s*;?\$',
      caseSensitive: false);
  print(pat.toString() + '\n');
  for (var st in statements) {
    if (!pat.hasMatch(st)) throw Exception('Invalid statement $st.');
    print('Statement passed: $st');
    var matches = pat.allMatches(st);
    for (var match in matches) {
      var columnsGroup = match.namedGroup('columns');
      print('columns: $columnsGroup');
      var tableGroup = match.namedGroup('table');
      print('table: $tableGroup');
      var whereGroup = match.namedGroup('where');
      print('where: $whereGroup');
      var joinGroup = match.namedGroup('join');
      print('join: $joinGroup');
      var orderGroup = match.namedGroup('orderby');
      print('order by: $orderGroup');
      print('');
    }
  }
}

void main(List<String> arguments) {
  //print('Hello world: ${console.calculate()}!');
  var whereSts = [
    'where col1 = 1',
    "where name like 'vini%'",
    'where myTable1.age < 30',
    'where col1 = 1 and col2 = 10',
    'where col1 = 1 or col2 = 10',
  ];
  //testWhereStatements(whereSts);
  var sts = [
    'select * from myTable;',
    'select col1, col2,col3 , col4 from myTable;',
    'select col1, col2,col3 , col4 from myTable where col1 = 1;',
    'select col1, col2,col3 , col4 from myTable where col1 = 1 order by col2 desc;',
    'select col1, col2,col3 , col4 from myTable where col1 = 1 order by myTable1.col2 desc;',
    'select * from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF;',
    "select * from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF where myTable1.Nome like 'vinicius%';",
    "select * from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF where myTable1.Nome like 'vinicius%' and col1 < 10;",
    "select * from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF where myTable1.Nome like 'vinicius%' order by myTable1.Age asc;",
    "select * from myTable1 where myTable1.Nome like 'vinicius%' order by myTable1.Age asc;",
    'select * from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF order by col1 asc;',
    "select * from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF where myTable1.Nome like 'vinicius%' order by col1 desc;",
    "select myTable1.col1 from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF where myTable1.Nome like 'vinicius%' order by myTable1.Age desc;",
    "select myTable1.col1 from myTable1 join myTable2 on myTable1.CPF > 60 where myTable1.Nome like 'vinicius%' order by myTable1.Age desc;",
  ];
  testStatements(sts);
  print('End.');
}
