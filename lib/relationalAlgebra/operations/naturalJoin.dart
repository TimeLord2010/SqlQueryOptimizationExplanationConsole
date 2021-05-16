import 'package:console/relationalAlgebra/util/dataSet.dart';
import 'package:console/relationalAlgebra/util/raRelationalOperator.dart';

class NaturalJoin implements RArelationalOperator {
  @override
  var source;

  @override
  String symbol = '⋈';

  @override
  var source2;

  @override
  DataSet process() {
    // TODO: implement process
    throw UnimplementedError();
  }
}