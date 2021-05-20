import 'package:console/relationalAlgebra/operations/projection.dart';
import 'package:console/relationalAlgebra/operations/selection.dart';
import 'package:console/relationalAlgebra/util/column.dart';
import 'package:console/relationalAlgebra/util/conditional.dart';
import 'package:console/relationalAlgebra/util/conditionalUnit.dart';
import 'package:console/relationalAlgebra/util/navigator.dart';

class SelectionAndConditional {
  Selection selection;
  Conditional conditional;
  SelectionAndConditional(Selection s, Conditional c) {
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
  for (var table in tables) {
    var op = RAnavigator.lookFor(nav: nav, table: table);
    if (op == null) throw Exception('Cannot find operator with source set to $table.');
    var cond = <ConditionalUnit>[];
    for (var selection in selections) {
      Conditional.loop(selection.condition, (c) {
        if (c.column.table == table) {
          cond.add(c);
        }
      });
    }
    var selection = Selection();
    selection.condition = Conditional.fromUnits(cond);
    selection.source = table;
    if (op.source is String && op.source == table) {
      for (var selection in selections) {
        var r = Conditional.remove(selection.condition, cond);
        if (r) {
          nav.remove(selection);
        }
      }
      op.source = selection;
    } else if (['⋈θ', '×', '⋈'].contains(op.symbol) && op.source2 is String && op.source2 == table) {
      op.source2 = selection;
    } else {
      print('tried overring source: ${op.source}. In expression: $op. For: $selection\n');
    }
  }
}

void setProjectionsToEspecificSelections(RAnavigator nav, List<String> tables) {
  nav.goTop();
  var allColumns = <Column>[];
  if (nav.expression is Projection) {
    var projection = nav.expression as Projection;
    projection.outputColumns.forEach((element) {
      allColumns.add(element);
    });
  } else {
    throw Exception('Top operator should be projection. found: ${nav.expression}');
  }
  for (var table in tables) {
    var op = RAnavigator.lookFor(nav: nav, table: table);
    if (op == null) throw Exception('Cannot find operator with source set to $table.');
    if (!(op is Selection)) throw Exception('Operator should be a selection.');
    var opParent = nav.parentOf(op);
    if (opParent == null) throw Exception('Cannot find parent of $op');
    var columns = allColumns.where((element) => element.table == table);
    var projection = Projection.fromColumns(columns.toList(), op);
    if (['⋈θ', '×', '⋈'].contains(opParent.symbol)) {
      if (opParent.source == op) {
        opParent.source = projection;
      } else if (opParent.source2 == op) {
        opParent.source2 = projection;
      } else {
        throw Exception('No branch was the original item.');
      }
    } else {
      opParent.source = projection;
    }
  }
}

dynamic optimize({op, List<String> tables}) {
  var nav = RAnavigator(op);
  setConditionalsToEspecificSelections(nav, tables);
  setProjectionsToEspecificSelections(nav, tables);
  nav.goTop();
  return nav.expression;
}
