import 'package:console/relationalAlgebra/util/dataSet.dart';
import 'package:console/relationalAlgebra/util/raRelationalOperator.dart';

class CrossProduct implements RArelationalOperator {

  @override
  var source;

  @override
  var source2;
  
  @override
  String symbol = '×';

  @override
  DataSet process() {
    // TODO: implement process
    throw UnimplementedError();
  }

}