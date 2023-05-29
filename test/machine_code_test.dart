import 'package:flutter_test/flutter_test.dart';
import 'package:machine_code/machine_code.dart';

void main() {
  test('Calculate machine code\'s length', () {
    final code = MachineCode();
    expect(code.md5.length, 32);
    expect(code.sha256.length, 64);
    expect(code.sha384.length, 96);
    expect(code.sha512.length, 128);
  });

  test('Test multiple generation', () {
    final code = MachineCode();
    var md5 = code.md5;
    var sha256 = code.sha256;
    var sha384 = code.sha384;
    var sha512 = code.sha512;
    for (var i = 0; i < 10000; i++) {
      expect(code.md5, md5);
      expect(code.sha256, sha256);
      expect(code.sha384, sha384);
      expect(code.sha512, sha512);
    }
  });
}
