import 'package:flutter_test/flutter_test.dart';
import 'package:machine_code/machine_code.dart';

void main() {
  test('Calculate machine code', () {
    final code = MachineCode();
    expect(code.md5.length, 32);
    expect(code.sha256.length, 64);
    expect(code.sha384.length, 96);
    expect(code.sha512.length, 128);
  });
}
