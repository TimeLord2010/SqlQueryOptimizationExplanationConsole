import 'package:console/relationalAlgebra/operations/projection.dart';
import 'package:console/relationalAlgebra/operations/selection.dart';
import 'package:console/relationalAlgebra/util/conditional.dart';
import 'package:console/relationalAlgebra/util/navigator.dart';
import 'package:console/relationalAlgebra/util/raOperator.dart';

void setConditionalsToEspecificSelections (RAnavigator nav, List<Conditional> conditionals) {
  conditionals ??= []; 
  if (nav.expression is Projection) {
    nav.goDown();
    setConditionalsToEspecificSelections(nav, conditionals);
  }
  if (nav.expression is Selection) {
    var exp = nav.expression as Selection;
    conditionals.add(exp.condition);
    setConditionalsToEspecificSelections(nav, conditionals);
  }
}

void optimize ({RAoperator op}) {

}