import 'package:console/relationalAlgebra/operations/selection.dart';
import 'package:console/relationalAlgebra/util/conditional.dart';
import 'package:console/relationalAlgebra/util/conditionalUnit.dart';
import 'package:console/relationalAlgebra/util/navigator.dart';

class SelectionAndConditional {
  Selection selection;
  Conditional conditional;
  SelectionAndConditional (Selection s, Conditional c) {
    selection = s;
    conditional = c;
  }
}

void setConditionalsToEspecificSelections(RAnavigator nav, List<String> tables) {
  var selections = <Selection>[];
  RAnavigator.loop(nav, (op, parent) {
    if (op is Selection) {
      selections.add(op);
    }
  });
  //print('tables: $tables');
  for (var table in tables) {
    //print('table: $table');
    var op = RAnavigator.lookFor(nav: nav, table: table);
    if (op == null) throw Exception('Cannot find operator with source set to $table.');
    var cond = <ConditionalUnit>[];
    for (var selection in selections) {
      //print('conditional loop: ');
      Conditional.loop(selection.condition, (c) {
        //print('c: $c');
        //print('table: ${c.column.table} == $table => ${c.column.table == table}');
        if (c.column.table == table) {
          //print('added');
          cond.add(c);
        }
      });
    }
    var selection = Selection();
    //print('conditionals empty? ${cond.length}');
    selection.condition = Conditional.fromUnits(cond);
    selection.source = table;
    if (op.source is String && op.source == table) {
      for (var selection in selections) {
        var r = Conditional.remove(selection.condition, cond);
        if (r) {
          nav.remove(selection);
        }
      }
      //print('overring source: ${op.source}. In expression: $op. For: $selection\n');
      op.source = selection;
    } else if (['⋈θ', '×', '⋈'].contains(op.symbol) && op.source2 is String && op.source2 == table) {
      //print('overring source: ${op.source2}. In expression: $op. For: $selection\n');
      op.source2 = selection;
    } else {
      print('tried overring source: ${op.source}. In expression: $op. For: $selection\n');
    }
  }
  // if (nav.expression is Projection) {
  //   nav.goDown();
  //   setConditionalsToEspecificSelections(nav, conditionals);
  // }
  // if (nav.expression is Selection) {
  //   var exp = nav.expression as Selection;
  //   conditionals.add(exp.condition);
  //   nav.goDown();
  //   setConditionalsToEspecificSelections(nav, conditionals);
  // }
}

dynamic optimize({op, List<String> tables}) {
  var nav = RAnavigator(op);
  setConditionalsToEspecificSelections(nav, tables);
  nav.goTop();
  return nav.expression;
}
