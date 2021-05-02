class WhereStatementUnit {

  String column;
  String op;
  String value;

  WhereStatementUnit (String s) {
    var whereComparatorRegExp = RegExp(whereComparatorPat);
    var matches = whereComparatorRegExp.allMatches(s)
    for (var match in matches) {
      
    }
  }

}