import 'package:console/relationalAlgebra/util/RAoperator.dart';
import 'package:console/relationalAlgebra/util/conditional.dart';
import 'package:console/relationalAlgebra/util/dataSet.dart';
import 'package:console/sql/sintax%20parser/whereStatement.dart';

class Selection implements RAoperator {
	
  @override
  var source;

  @override
  final String symbol = 'σ';

  Conditional condition;

  Selection.fromSql(WhereStatement where, String defaultTable) {
    condition = Conditional.fromWhereStatement(where, defaultTable);
  }

  @override
  DataSet process() {
    throw UnimplementedError();
  }

  @override
  String toString() {
    // TODO: implement toString
    return '$symbol {$condition}($source)';
  }
  
}