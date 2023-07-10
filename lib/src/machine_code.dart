import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart' as crypto;
import 'package:machine_code/src/machine_code_strategy.dart';

class MachineCode {
  MachineCode() {
    _os = Platform.operatingSystem;
    _strategy = _implementStrategy();
    _rawMachineCode = _generateMachineCode();
  }

  late String _os;
  late String _rawMachineCode;
  late MachineCodeStrategy _strategy;

  /// Use **md5** algorithm to generate **32** bytes length machine code
  String get md5 {
    return crypto.md5.convert(utf8.encode(_rawMachineCode)).toString();
  }

  /// Use **sha256** algorithm to generate **64** bytes length machine code
  String get sha256 {
    return crypto.sha256.convert(utf8.encode(_rawMachineCode)).toString();
  }

  /// Use **sha384** algorithm to generate **128** bytes length machine code
  String get sha384 {
    return crypto.sha384.convert(utf8.encode(_rawMachineCode)).toString();
  }

  /// Use **sha512** algorithm to generate **256** bytes length machine code
  String get sha512 {
    return crypto.sha512.convert(utf8.encode(_rawMachineCode)).toString();
  }

  MachineCodeStrategy _implementStrategy() {
    switch (_os) {
      case 'linux':
        return LinuxMachineCodeStrategy();
      case 'macos':
        return MacMachineCodeStrategy();
      default:
        throw UnsupportedError('Unsupported OS: $_os');
    }
  }

  String _generateMachineCode() {
    String disk = _strategy.getDiskUUID();
    return 'DISK@$disk';
  }
}
