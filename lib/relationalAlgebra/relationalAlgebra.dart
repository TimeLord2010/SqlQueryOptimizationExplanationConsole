import 'dart:core';

import 'package:console/sql/sintax%20parser/joinStatement.dart';
import 'package:console/sql/sintax%20parser/joinStatementUnit.dart';
import 'package:console/sql/sintax%20parser/sqlParser.dart';
import 'package:console/sql/sintax%20parser/whereStatement.dart';
import 'package:console/sql/sintax%20parser/whereStatementUnit.dart';

RelationalAlgebraExpression sqlToRelationalAlgebra(SqlParser parsed) {
  var projection = Projection(parsed.table, parsed.columns);
  var selection = Selection.fromSql(parsed.where, parsed.table);
  projection.source = selection;
  if (parsed.join == null) {
    selection.source = parsed.table;
  } else {
    selection.source = ThetaJoin.build(parsed.join, parsed.table);
  }
  return projection;
}

class DataSet {
  List<Column> sourceColumns;
  List<dynamic> sourceData;
}

class RelationalAlgebraExpression {
  var source;

  final String symbol = '';

  DataSet process() {
    throw Exception(
        'RelationalAlgebraExpression.process must not be cannot directly.');
  }
}

class Projection implements RelationalAlgebraExpression {

  @override
  var source;

  @override
  final String symbol = 'π';

  List<Column> outputColumns;

  Projection(String defaultTable, List<String> cols) {
    outputColumns = [];
    for (var col in cols) {
      if (col.contains('.')) {
        var parts = col.split('.');
        outputColumns.add(Column(parts[0], parts[1]));
      } else {
        outputColumns.add(Column(col, defaultTable));
      }
    }
  }

  @override
  DataSet process() {
    // TODO: implement process
    throw UnimplementedError();
  }

  @override
  String toString() {
    return symbol + '[' + outputColumns.toString() + ']' + '($source)';
  }
}

class Selection implements RelationalAlgebraExpression {
  @override
  var source;

  @override
  String symbol = 'σ';

  Conditional condition;

  Selection.fromSql(WhereStatement where, String defaultTable) {
    condition = Conditional.fromWhereStatement(where, defaultTable);
  }

  @override
  DataSet process() {
    throw UnimplementedError();
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
  
}

class CrossProduct implements RelationalAlgebraExpression {
  @override
  var source;

  @override
  String symbol = '×';

  @override
  DataSet process() {
    // TODO: implement process
    throw UnimplementedError();
  }
}

class NaturalJoin implements RelationalAlgebraExpression {
  @override
  var source;

  @override
  String symbol = '⋈';

  @override
  DataSet process() {
    // TODO: implement process
    throw UnimplementedError();
  }
}

class ThetaJoin implements RelationalAlgebraExpression {

  ThetaJoin();

  Conditional condition;

  @override
  var source;

  var source2;

  @override
  String symbol = '⋈θ';

  @override
  DataSet process() {
    // TODO: implement process
    throw UnimplementedError();
  }

  static ThetaJoin build(obj, defaultTable, {table}) {
    var theta = ThetaJoin();
    if (obj is JoinStatement) {
      theta.source = defaultTable;
      var a = obj;
      theta.condition =
          Conditional.fromWhereStatement(a.statement[0].where, defaultTable);
      if (a.statement.length > 1) {
        theta.source2 = build(a.statement.skip(0), defaultTable, table: a.statement[0].joinedTable);
      } else if (a.statement.length == 1) {
        theta.source2 = a.statement[0].joinedTable;
      } else {
        throw Exception('Invalid number of statements in join.');
      }
    } else if (obj is Iterable<JoinStatementUnit>) {
      var a = obj;
      theta.source = table;
      theta.condition = Conditional.fromWhereStatement(a.elementAt(0).where, defaultTable);
      if (a.length > 1) {
        theta.source2 = build(a.skip(1), defaultTable, table: a.elementAt(0).joinedTable);
      } else if (a.length == 1) {
        theta.source2 = a.elementAt(0).joinedTable;
      } else {
        throw Exception('Invalid number of statements in join.');
      }
    } else {
      throw Exception('Invalid type.');
    }
    return theta;
  }
}

class Conditional {
  dynamic left;
  bool and;
  dynamic right;

  Conditional();

  static Conditional fromWhereStatement(WhereStatement st, String defaultTable) {
    if (st == null) return null;
    var c = Conditional();
    if (st.left is WhereStatement) {
      c.left = Conditional.fromWhereStatement(st.left, defaultTable);
    } else if (st.left is WhereStatementUnit) {
      c.left = ConditionalUnit.fromWhereUnit(st.left, defaultTable);
    }
    if (st.right is WhereStatement) {
      c.and = st.and;
      c.right = Conditional.fromWhereStatement(st.right, defaultTable);
    } else if (st.right is WhereStatementUnit) {
      c.and = st.and;
      c.right = ConditionalUnit.fromWhereUnit(st.right, defaultTable);
    }
    return c;
  }
}

class ConditionalUnit {
  Column column;
  String op;
  String value;

  ConditionalUnit();

  ConditionalUnit.fromWhereUnit(WhereStatementUnit unit, String defaultTable) {
    if (unit.column.contains('.')) {
      var parts = unit.column.split('.');
      column = Column(parts[0], parts[1]);
    } else {
      column = Column(defaultTable, unit.column);
    }
    op = unit.op;
    value = unit.value;
  }
}

class Column {
  String table;
  String name;

  Column(String _table, String _name) {
    table = _table;
    name = _name;
  }
}
