import 'package:console/relationalAlgebra/util/conditionalUnit.dart';
import 'package:console/sql/sintax%20parser/whereStatement.dart';
import 'package:console/sql/sintax%20parser/whereStatementUnit.dart';

class Conditional {
  Conditional parent;
  dynamic left;
  bool and;
  dynamic right;

  Conditional();

  Conditional.fromUnits(Iterable<ConditionalUnit> units, {Conditional p}) {
    if (units.isEmpty) {
      throw Exception('Cannot build conditional with no units.');
    }
    parent = p;
    left = units.first;
    if (units.length == 2) {
      and = true;
      right = units.elementAt(1);
    } else {
      and = true;
      right = Conditional.fromUnits(units.skip(1), p: this);
    }
  }

  static void loop(Conditional conditional, Function(ConditionalUnit) func) {
    if (conditional.left is Conditional) {
      loop(conditional.left, func);
    } else if (conditional.left is ConditionalUnit) {
      func(conditional.left);
    }
    if (conditional.right is Conditional) {
      loop(conditional.right, func);
    } else if (conditional.right is ConditionalUnit) {
      func(conditional.right);
    }
  }

  static Conditional fromWhereStatement(WhereStatement st, String defaultTable, {Conditional parent}) {
    if (st == null) return null;
    var c = Conditional();
    if (st.left is WhereStatement) {
      c.left = Conditional.fromWhereStatement(st.left, defaultTable, parent: c);
    } else if (st.left is WhereStatementUnit) {
      c.left = ConditionalUnit.fromWhereUnit(st.left, defaultTable, p: c);
    }
    if (st.right is WhereStatement) {
      c.and = st.and;
      c.right = Conditional.fromWhereStatement(st.right, defaultTable, parent: c);
    } else if (st.right is WhereStatementUnit) {
      c.and = st.and;
      c.right = ConditionalUnit.fromWhereUnit(st.right, defaultTable, p: c);
    }
    return c;
  }

  @override
  String toString() {
    if (and != null && right != null) {
      var sep = and ? '˄' : '˅';
      return '$left $sep $right';
    } else {
      return left.toString();
    }
  }
}
