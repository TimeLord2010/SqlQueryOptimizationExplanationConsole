import 'package:console/relationalAlgebra/util/conditional.dart';
import 'package:console/relationalAlgebra/util/dataSet.dart';
import 'package:console/relationalAlgebra/util/raRelationalOperator.dart';
import 'package:console/sql/sintax%20parser/joinStatement.dart';
import 'package:console/sql/sintax%20parser/joinStatementUnit.dart';

class ThetaJoin implements RArelationalOperator {
  ThetaJoin();

  Conditional condition;

  @override
  var source;

  @override
  var source2;

  @override
  final String symbol = '⋈θ';

  @override
  DataSet process() {
    // TODO: implement process
    throw UnimplementedError();
  }

  static ThetaJoin lastTheta (ThetaJoin join) {
    if (join.source is ThetaJoin) {
      return lastTheta(join.source);
    }
    if (join.source2 is ThetaJoin) {
      return lastTheta(join.source2);
    }
    return join;
  }

  static ThetaJoin reverse (ThetaJoin join) {
    print('reverse param: $join');
    var joins = <ThetaJoin>[];
    while (join.source is ThetaJoin || join.source2 is ThetaJoin) {
      if (join.source is ThetaJoin) {
        joins.add(join.source);
      } else if (join.source2) {
        joins.add(join.source2);
      }
    }
    print(joins);
    for (var i = joins.length - 1; i >= 1; i--) {
      var currentJoin = joins[i];
      var nextJoin = joins[i-1];
      var oldSource = currentJoin.source;
      currentJoin.source = nextJoin;
      if (nextJoin.source == currentJoin) {
        nextJoin.source = oldSource;
      } else {
        nextJoin.source2 = oldSource;
      }
    }
    return joins.last;
  }

  static ThetaJoin build(obj, defaultTable, {table}) {
    var theta = ThetaJoin();
    if (obj is JoinStatement) {
      var a = obj;
      theta.source = defaultTable;
      theta.condition = Conditional.fromWhereStatement(a.statement[0].where, defaultTable);
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
    return reverse(theta);
    //return theta;
  }

  @override
  String toString() {
    return '($source)$symbol{$condition}($source2)';
  }
}
