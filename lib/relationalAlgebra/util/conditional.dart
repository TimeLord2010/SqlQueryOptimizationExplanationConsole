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
    } else if (units.length > 1) {
      and = true;
      right = Conditional.fromUnits(units.skip(1), p: this);
    }
  }

  // if return true, delete entira conditional
  static bool remove(Conditional conditional, Iterable<ConditionalUnit> units) {
    for (var unit in units) {
      if (conditional.left is Conditional) {
        var result = remove(conditional.left, [unit]);
        if (result) return true;
      } else if (conditional.left is ConditionalUnit) {
        if (conditional.left == unit) {
          conditional.left = null;
          return fix(conditional, true);
        }
      }
      if (conditional.right is Conditional) {
        var result = remove(conditional.right, [unit]);
        if (result) return true;
      } else if (conditional.right is ConditionalUnit) {
        if (conditional.right == unit) {
          conditional.right = null;
          return fix(conditional, false);
        }
      }
    }
    return false;
  }

  // if return true, delete entire conditional
  static bool fix(Conditional conditional, bool left) {
    var parent = conditional.parent;
    if (left) {
      if (conditional.right != null) {
        conditional.left = conditional.right;
        return false;
      } else {
        if (parent == null) {
          return true;
        } else {
          if (parent.left == conditional) {
            parent.left = null;
            return fix(parent, true);
          } else if (parent.right == conditional) {
            parent.right = null;
            return fix(parent, false);
          } else {
            throw Exception("couldn't find conditional.");
          }
        }
      }
    } else {
      if (conditional.left != null) {
        return false;
      } else {
        if (parent == null) {
          return true;
        } else {
          if (parent.left == conditional) {
            parent.left = null;
            return fix(parent, true);
          } else if (parent.right == conditional) {
            parent.right = null;
            return fix(parent, false);
          } else {
            throw Exception("couldn't find conditional.");
          }
        }
      }
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
