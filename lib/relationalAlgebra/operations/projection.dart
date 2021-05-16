import 'package:console/relationalAlgebra/util/RAoperator.dart';
import 'package:console/relationalAlgebra/util/column.dart';
import 'package:console/relationalAlgebra/util/dataSet.dart';

class Projection implements RAoperator {

  @override
  var source;

  @override
  final String symbol = 'π';

  List<Column> outputColumns;

  Projection(String defaultTable, List<String> cols) {
    outputColumns = [];
    for (var col in cols) {
      if (col.contains('.')) {
        var parts = col.split('.');
        outputColumns.add(Column(parts[0], parts[1]));
      } else {
        outputColumns.add(Column(col, defaultTable));
      }
    }
  }

  @override
  DataSet process() {
    // TODO: implement process
    throw UnimplementedError();
  }

  @override
  String toString() {
    return '$symbol $outputColumns ($source)';
  }
}