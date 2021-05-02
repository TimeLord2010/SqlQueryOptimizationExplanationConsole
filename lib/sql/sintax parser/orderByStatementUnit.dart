class OrderByStatementUnit {

  String column;
  bool asc;

  OrderByStatementUnit (RegExpMatch match) {
    column = match.namedGroup('orderByColumn');
    asc = match.namedGroup('orderBySort') == 'asc';
  }

}