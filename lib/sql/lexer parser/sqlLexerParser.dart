import 'package:console/sql/sintax%20parser/sqlParser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var dbmetadata_url =
    'https://8n242oo4sj.execute-api.sa-east-1.amazonaws.com/prod/mysql/getmetadata';

Future<List<TableInfo>> getDatabaseMetaData() async {
  var response = await http.post(Uri.parse(dbmetadata_url));
  if (response.statusCode != 200) {
    var message = response.body;
    throw Exception('Failed to get database meta data. Body: $message');
  }
  var decoded = utf8.decode(response.body.runes.toList());
  var metadata = json.decode(decoded);
  if (!(metadata is Map)) throw Exception('Meta data response was not a map.');
  if (!metadata.containsKey('result')) {
    throw Exception('Result not found in meta data response.');
  }
  var result = metadata['result'];
  if (!(result is List)) throw Exception('Result must be a list.');
  return result.map<TableInfo>((e) => TableInfo(e)).toList();
}

class ColumnInfo {
  String name;
  String type;
  bool is_nullable;

  ColumnInfo(param) {
    name = param['COLUMN_NAME'];
    type = param['DATA_TYPE'];
    is_nullable = param['IS_NULLABLE'] == 'YES';
  }
}

class TableInfo {
  String table;
  List<ColumnInfo> columns = [];

  TableInfo(param) {
    table = param['TABLE_NAME'];
    columns = param['COLUMNS'].map<ColumnInfo>((x) => ColumnInfo(x)).toList();
  }
}

Future<List<TableInfo>> getRelevantTableInfo(SqlParser sqlParser) async {
  var tables = sqlParser.getTables();
  var tablesInfo = await getDatabaseMetaData();
  return tablesInfo.where((element) => tables.contains(element.table)).toList();
}

void checkColumnLexaly(List<TableInfo> tablesInfo, column) {
  if (column is Iterable) {
    for (var c in column) {
      checkColumnLexaly(tablesInfo, c);
    }
    return;
  }
  if (column == '*') {
    return;
  }
  if (column.contains('.')) {
    var table_column = column.split('.');
    var table_name = table_column[0];
    checkTableLexaly(tablesInfo, table_name);
  } else {
    var column_count = tablesInfo
        .where((element) =>
            element.columns.any((columnInfo) => columnInfo.name == column))
        .length;
    if (column_count == 0) {
      throw Exception('Column $column does not exist in any table.');
    } else if (column_count != 1) {
      throw Exception('Ambiguous column $column.');
    }
  }
}

void checkTableLexaly(List<TableInfo> tablesInfo, table) {
  if (table is Iterable) {
    for (var t in table) {
      checkTableLexaly(tablesInfo, t);
    }
    return;
  }
  var table_exists = tablesInfo.any((element) => element.table == table);
  if (!table_exists) {
    throw Exception('Table $table does not exist.');
  }
}

Future checkLexaly(SqlParser sqlParser) async {
  var tablesInfo = await getRelevantTableInfo(sqlParser);
  checkTableLexaly(tablesInfo, sqlParser.table);
  if (sqlParser.join != null) {
    checkTableLexaly(tablesInfo, sqlParser.join.getTables());
    checkColumnLexaly(tablesInfo, sqlParser.join.getColumns());
  }
  if (sqlParser.where != null) {
    checkTableLexaly(tablesInfo, sqlParser.where.getTables());
    checkColumnLexaly(tablesInfo, sqlParser.where.getColumns());
  }
  if (sqlParser.orderBy != null) {
    checkTableLexaly(tablesInfo, sqlParser.orderBy.getTables());
    checkColumnLexaly(tablesInfo, sqlParser.orderBy.getColumns());
  }
  checkColumnLexaly(tablesInfo, sqlParser.columns);
}
