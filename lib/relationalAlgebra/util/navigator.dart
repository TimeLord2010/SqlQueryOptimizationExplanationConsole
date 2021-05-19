import 'package:console/relationalAlgebra/util/raOperator.dart';
import 'package:console/relationalAlgebra/util/raRelationalOperator.dart';

class RAnavigator {
  List<dynamic> ancestors = [];
  dynamic expression;
  int level = 0;

  bool get isTop {
    return level <= 0 || ancestors.isEmpty;
  }

  bool get isLeaf {
    return expression.source is String;
  }

  bool get isBranch {
    return ['⋈θ', '×', '⋈'].contains(expression.symbol);
    //return expression is RArelationalOperator;
  }

  RAnavigator(op) {
    if (op is String) {
      throw Exception('String $op is not a valid argument type.');
    }
    expression = op;
  }

  bool goDown({bool left = true}) {
    if (expression == null || expression.source is String) return false;
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
    return true;
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

  void remove (op) {
    if (['⋈θ', '×', '⋈'].contains(op.symbol)) {
      throw Exception('The operation remove does not support branch operators.');
    }
    loop(this, (item, parent) {
      if (item == op) {
        parent.source = item.source;
      }
    });
  }

  static void loop(RAnavigator nav, Function(dynamic, dynamic) func, {bool shouldGoTop = true}) {
    if (shouldGoTop) nav.goTop();
    while (!nav.isLeaf) {
      var parent = nav.ancestors.isEmpty ? null: nav.ancestors.last;
      func(nav.expression, parent);
      if (nav.isBranch) {
        if (nav.expression.source is String) {
          func(nav.expression.source, parent);
          break;
        } else {
          loop(RAnavigator(nav.expression.source), func, shouldGoTop: false);
        }
        if (nav.expression.source2 is String) {
          func(nav.expression.source2, parent);
          break;
        } else {
          loop(RAnavigator(nav.expression.source2), func, shouldGoTop: false);
        }
      } else {
        if (nav.expression == null || nav.expression.source is String) {
          break;
        } else {
          nav.goDown();
        }
      }
    }
  }

  static dynamic lookFor({RAnavigator nav, String table, bool reset = true, bool left = true, Function(RAoperator) func}) {
    // print('----');
    // print('looking for: $table');
    // print('expression: ${nav.expression}');
    if (reset) nav.goTop();
    // if (nav.expression.source is String) {
    //   String source = nav.expression.source;
    //   if (source == table) return nav.expression;
    //   return null;
    // }
    while (true) {
      if (func != null) func(nav.expression);
      // print('while expression: ${nav.expression}');
      // print('is branch ${nav.isBranch}');
      if (nav.isBranch) {
        if (nav.expression.source is String) {
          if (nav.expression.source == table) {
            //print('found! Expression: ${nav.expression}');
            return nav.expression;
          }
        } else {
          //print('checking left source: ${nav.expression.source}');
          var result = lookFor(nav: RAnavigator(nav.expression.source), table: table, reset: false, func: func);
          if (result != null) return result;
        }
        if (nav.expression.source2 is String) {
          return nav.expression.source2 == table ? nav.expression : null;
        } else {
          //print('checking left source2: ${nav.expression.source2}');
          return lookFor(nav: RAnavigator(nav.expression.source2), table: table, left: false, reset: false, func: func);
        }
      } else {
        if (nav.expression == null || nav.expression.source is String) {
          if (nav.expression.source is String && nav.expression.source == table) {
            return nav.expression;
          }
          break;
        } else {
          nav.goDown(left: left);
        }
      }
    }
    return null;
  }
}
