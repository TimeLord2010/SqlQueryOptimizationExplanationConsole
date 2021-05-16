import 'package:console/relationalAlgebra/util/conditionalUnit.dart';
import 'package:console/sql/sintax%20parser/whereStatement.dart';
import 'package:console/sql/sintax%20parser/whereStatementUnit.dart';

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
