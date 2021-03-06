import 'dart:convert';

import 'package:console/console.dart' as console;
import 'package:console/queryOptimizer/queryOptimizer.dart';
import 'package:console/relationalAlgebra/util/raExpression.dart';
import 'package:console/sql/sintax parser/sqlParser.dart';
import 'package:console/sql/lexer parser/sqlLexerParser.dart';

String getPrettyJSONString(jsonObject) {
  var encoder = JsonEncoder.withIndent('     ');
  return encoder.convert(jsonObject);
}

Future processSqls(List<String> sqls) async {
  print('');
  for (var sql in sqls) {
    print(sql + '\n');
    var parser = SqlParser(sql);
    await checkLexaly(parser);
    var ra = sqlToRelationalAlgebra(parser);
    print(ra.toString() + '\n');
    var optimized = optimize(op: ra, tables: parser.getTables().toList());
    print('optimized: $optimized\n');
    print('');
  }
}

void main(List<String> arguments) async {
  print('Hello world: ${console.calculate()}!');
  var a = '';
  a += 'select idMovimentacao, DataMovimentacao, Movimentacao.Descricao, TipoMovimento.DescMovimentacao, Categoria.DescCategoria, Contas.Descricao, Valor ';
  a += 'from Movimentacao ';
  a += 'join TipoMovimento on TipoMovimento.idTipoMovimento = Movimentacao.TipoMovimento_idTipoMovimento ';
  a += 'join Categoria on Categoria.idCategoria = Movimentacao.Categoria_idCategoria ';
  a += 'join Contas on Contas.idConta = Movimentacao.Contas_idConta ';
  a += "where TipoMovimento.DescMovimentacao = 'Débito' and Categoria.DescCategoria = 'Salário' and Valor > 10 and Contas.Descricao = 'Bitcoin';";
  var sts = [
    //'select * from Usuario;',
    //'select Nome, Número,Bairro , CEP from Usuario;',
    //"select Nome, Número,Bairro , CEP from Usuario where CEP = '60';",
    //"select Nome, Número,Bairro , CEP from Usuario where CEP = '60' order by Número desc;",
    //'select * from Movimentacao join Categoria on Movimentacao.Categoria_idCategoria = Categoria.idCategoria;',
    //"select * from Movimentacao join Categoria on Movimentacao.Categoria_idCategoria = Categoria.idCategoria where DescCategoria = 'test' order by idCategoria desc;",
    a
    // "select * from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF where myTable1.Nome like 'vinicius%';",
    // "select * from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF where myTable1.Nome like 'vinicius%' and col1 < 10;",
    // "select * from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF where myTable1.Nome like 'vinicius%' order by myTable1.Age asc;",
    // "select * from myTable1 where myTable1.Nome like 'vinicius%' order by myTable1.Age asc;",
    // 'select * from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF order by col1 asc;',
    // "select * from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF where myTable1.Nome like 'vinicius%' order by col1 desc;",
    // "select myTable1.col1 from myTable1 join myTable2 on myTable1.CPF = myTable2.CPF where myTable1.Nome like 'vinicius%' order by myTable1.Age desc;",
    // "select myTable1.col1 from myTable1 join myTable2 on myTable1.CPF > 60 where myTable1.Nome like 'vinicius%' order by myTable1.Age desc;",
    // "select myTable1.col1 from myTable1 join myTable2 on myTable1.CPF > 60 join myTable3 on myTable1.Nome = myTable2.Nome where myTable1.Nome like 'vinicius%' or myTable2.Age < 20 and myTable3.Address <> null order by myTable1.Age desc, myTable2.Nome asc;",

    //"select myTable1.col1 from myTable1 join myTable2 on myTable1.CPF > 60 join myTable3 on myTable1.Nome = myTable2.Nome where myTable1.Nome like 'vinicius%' or myTable2.Age < 20 and myTable3.Address <> null order by myTable1.Age desc, myTable2.Nome = '';",
  ];
  await processSqls(sts);
}
