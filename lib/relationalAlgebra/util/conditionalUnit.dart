import 'package:console/relationalAlgebra/util/column.dart';
import 'package:console/relationalAlgebra/util/conditional.dart';
import 'package:console/sql/sintax%20parser/whereStatementUnit.dart';

class ConditionalUnit {

  Conditional parent;
  Column column;
  String op;
  String value;

  ConditionalUnit();

  ConditionalUnit.fromWhereUnit(WhereStatementUnit unit, String defaultTable, {Conditional p}) {
    parent = p;
    if (unit.column.contains('.')) {
      var parts = unit.column.split('.');
      column = Column(parts[0], parts[1]);
    } else {
      column = Column(defaultTable, unit.column);
    }
    op = unit.op;
    value = unit.value;
  }

  @override
  String toString() {
    return '$column $op $value';
  }
  
}