import 'package:console/relationalAlgebra/operations/projection.dart';
import 'package:console/relationalAlgebra/operations/selection.dart';
import 'package:console/relationalAlgebra/operations/thetaJoin.dart';
import 'package:console/relationalAlgebra/util/dataSet.dart';
import 'package:console/sql/sintax%20parser/sqlParser.dart';

class RAexpression {
  DataSet process() {
    throw Exception('RelationalAlgebraExpression.process must not be cannot directly.');
  }
}

RAexpression sqlToRelationalAlgebra(SqlParser parsed) {
  var projection = Projection(parsed.table, parsed.columns);
  if (parsed.where != null) {
    var selection = Selection.fromSql(parsed.where, parsed.table);
    projection.source = selection;
    if (parsed.join == null) {
      selection.source = parsed.table;
    } else {
      selection.source = ThetaJoin.build(parsed.join, parsed.table);
    }
  } else if (parsed.join != null) {
	  projection.source = ThetaJoin.build(parsed.join, parsed.table);
  } else {
	  projection.source = parsed.table;
  }
  return projection;
}
