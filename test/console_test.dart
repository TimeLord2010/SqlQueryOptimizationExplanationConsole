import 'package:console/console.dart';
import 'package:test/test.dart';

void main() {
  print('begin test');
  var pat = RegExp('select .* from .*;?', caseSensitive: false);
  test('basic select', () {
    var sts = 'select * from myTable;';
    expect(pat.hasMatch(sts), true,  reason: 'Basic select did not work.');
    sts = 'select * from myTable';
    expect(pat.hasMatch(sts), true);
  });
}
