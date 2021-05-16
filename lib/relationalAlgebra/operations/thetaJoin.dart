import 'package:console/relationalAlgebra/util/RAoperator.dart';
import 'package:console/relationalAlgebra/util/conditional.dart';
import 'package:console/relationalAlgebra/util/dataSet.dart';
import 'package:console/sql/sintax%20parser/joinStatement.dart';
import 'package:console/sql/sintax%20parser/joinStatementUnit.dart';

class ThetaJoin implements RAoperator {

  ThetaJoin();

  Conditional condition;

  @override
  var source;

  var source2;

  @override
  final String symbol = '⋈θ';

  @override
  DataSet process() {
    // TODO: implement process
    throw UnimplementedError();
  }

  static ThetaJoin build(obj, defaultTable, {table}) {
    var theta = ThetaJoin();
    if (obj is JoinStatement) {
      theta.source = defaultTable;
      var a = obj;
      theta.condition =
          Conditional.fromWhereStatement(a.statement[0].where, defaultTable);
      if (a.statement.length > 1) {
        theta.source2 = build(a.statement.skip(1), defaultTable, table: a.statement[0].joinedTable);
      } else if (a.statement.length == 1) {
        theta.source2 = a.statement[0].joinedTable;
      } else {
        throw Exception('Invalid number of statements in join.');
      }
    } else if (obj is Iterable<JoinStatementUnit>) {
      var a = obj;
      theta.source = table;
      theta.condition = Conditional.fromWhereStatement(a.elementAt(0).where, defaultTable);
      if (a.length > 1) {
        theta.source2 = build(a.skip(1), defaultTable, table: a.elementAt(0).joinedTable);
      } else if (a.length == 1) {
        theta.source2 = a.elementAt(0).joinedTable;
      } else {
        throw Exception('Invalid number of statements in join.');
      }
    } else {
      throw Exception('Invalid type.');
    }
    return theta;
  }

  @override
  String toString() {
    return '($source)$symbol{$condition}($source2)';
  }

}