import 'package:console/relationalAlgebra/operations/selection.dart';
import 'package:console/relationalAlgebra/util/conditional.dart';
import 'package:console/relationalAlgebra/util/conditionalUnit.dart';
import 'package:console/relationalAlgebra/util/navigator.dart';
import 'package:console/relationalAlgebra/util/raOperator.dart';

void setConditionalsToEspecificSelections(RAnavigator nav, List<String> tables, {List<Conditional> conditionals}) {
  conditionals ??= [];
  RAnavigator.loop(nav, (op) {
    if (op is Selection) {
      var s = op as Selection;
      conditionals.add(s.condition);
    }
  });
  for (var table in tables) {
    var op = RAnavigator.lookFor(nav: nav, table: table);
    if (op == null) throw Exception('Cannot find operator with source set to $table.');
    var cond = <ConditionalUnit>[];
    for (var conditional in conditionals) {
      Conditional.loop(conditional, (c) {
        if (c.column.table == table) {
          cond.add(c);
        }
      });
    }
    var selection = Selection();
    selection.condition = Conditional.fromUnits(cond);
    selection.source = table;
    op.source = selection;
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

void optimize({op, List<String> tables}) {
  var nav = RAnavigator(op);
  setConditionalsToEspecificSelections(nav, tables);
}
