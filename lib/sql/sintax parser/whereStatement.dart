import 'package:console/sql/sintax%20parser/whereStatementUnit.dart';

import '../../stringUtil.dart';

class WhereStatement {
  dynamic left;
  bool and;
  dynamic right;

  WhereStatement(String statement) {
    var parts = splitOnce(statement, RegExp(' and ', caseSensitive: false));
    if (parts.length == 2) {
      left = WhereStatement(parts[0]);
      and = true;
      right = WhereStatement(parts[1]);
      return;
    }
    parts = splitOnce(statement, RegExp(' or ', caseSensitive: false));
    if (parts.length == 2) {
      left = WhereStatement(parts[0]);
      and = false;
      right = WhereStatement(parts[1]);
      return;
    }
    left = WhereStatementUnit(statement);
    and = null;
    right = null;
  }

  Set<String> getTables() {
    var tables = <String>{};
    if (left is WhereStatement || left is WhereStatementUnit) {
      tables.addAll(left.getTables());
    }
    if (right is WhereStatement || right is WhereStatementUnit) {
      tables.addAll(right.getTables());
    }
    return tables;
  }

  Set<String> getColumns() {
    var columns = <String>{};
    if (left is WhereStatement || left is WhereStatementUnit) {
      columns.addAll(left.getColumns());
    }
    if (right is WhereStatement || right is WhereStatementUnit) {
      columns.addAll(right.getColumns());
    }
    return columns;
  }

  Map<String, dynamic> toJson() {
    var result = <String, dynamic>{};
    if (left is WhereStatementUnit || left is WhereStatement) {
      result['left'] = left.toJson();
    } else {
      result['left'] = 'Invalid type for left';
    }
    if (right is WhereStatement || right is WhereStatementUnit) {
      result['and'] = and;
      result['right'] = right.toJson();
    }
    return result;
  }

  static void loop(WhereStatement where, Function(WhereStatementUnit) func) {
    if (where == null) return;
    if (where.left is WhereStatement) {
      loop(where, func);
    } else if (where.left is WhereStatementUnit) {
      func(where.left);
    }
    if (where.right is WhereStatement) {
      loop(where.right, func);
    } else if (where.right is WhereStatementUnit) {
      func(where.right);
    }
  }
}
