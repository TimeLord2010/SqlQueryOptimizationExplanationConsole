class OrderByStatementUnit {

  String column;
  bool asc;

  OrderByStatementUnit (RegExpMatch match) {
    column = match.namedGroup('orderByColumn');
    asc = match.namedGroup('orderBySort') == 'asc';
  }

  Map<String, dynamic> toJson() {
    return {
      'column': column,
      'asc': asc
    };
  }

}