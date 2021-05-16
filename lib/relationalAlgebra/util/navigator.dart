import 'package:console/relationalAlgebra/util/raOperator.dart';
import 'package:console/relationalAlgebra/util/raRelationalOperator.dart';

class RAnavigator {

  List<RAoperator> ancestors;
  RAoperator expression;
  int level = 0;

  bool get isTop {
    return level <= 0 || ancestors.isEmpty;
  }

  bool get isLeaf {
    return expression.source is String;
  }

  bool get isBranch {
    return expression is RArelationalOperator;
  }

  RAnavigator(RAoperator op) {
    expression = op;
  }

  void goDown({bool left = true}) {
    if (expression.source is RAoperator) {
      ancestors.add(expression);
      level += 1;
      if (isBranch) {
        RArelationalOperator relational = expression.source;
        if (left) {
          expression = relational.source;
        } else {
          expression = relational.source2;
        }
      } else {
        expression = expression.source;
      }
    }
  }

  void goUp() {
    if (isTop) return;
    var lastAncestor = ancestors.removeLast();
    expression = lastAncestor;
    level -= 1;
  }

  void goTop() {
    while (!isTop) {
      goUp();
    }
  }

  static RAoperator lookFor({RAnavigator nav, String table, bool reset = true, bool left = true}) {
    if (reset) nav.goTop();
    while (!nav.isLeaf) {
      if (nav.expression.source is String) {
        String source = nav.expression.source;
        if (source == table) return nav.expression;
      } else {
        if (nav.isBranch) {
          var nav2 = RAnavigator(nav.expression);
          var result = lookFor(nav: nav2, table: table);
          if (result != null) return result;
          result = lookFor(nav: nav, table: table, left: false);
          return result;
        } else {
          nav.goDown();
        }
      }
    }
    return null;
  }
}
