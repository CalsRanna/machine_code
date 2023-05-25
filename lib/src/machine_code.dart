import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/foundation.dart';
import 'package:machine_code/src/machine_code_strategy.dart';

class MachineCode {
  MachineCode({this.salt}) {
    _os = Platform.operatingSystem;
    _strategy = _implementStrategy();
    _rawMachineCode = _generateMachineCode();
    debugPrint(_rawMachineCode);
  }

  String? salt;
  late String _os;
  late String _rawMachineCode;
  late MachineCodeStrategy _strategy;

  /// Use **md5** algorithm to generate **32** bytes length machine code
  String get md5 {
    final hashed = crypto.md5.convert(utf8.encode(_rawMachineCode)).toString();
    debugPrint(hashed);
    return hashed;
  }

  /// Use **sha256** algorithm to generate **64** bytes length machine code
  String get sha256 {
    final hashed =
        crypto.sha256.convert(utf8.encode(_rawMachineCode)).toString();
    debugPrint(hashed);
    return hashed;
  }

  /// Use **sha384** algorithm to generate **128** bytes length machine code
  String get sha384 {
    final hashed =
        crypto.sha384.convert(utf8.encode(_rawMachineCode)).toString();
    debugPrint(hashed);
    return hashed;
  }

  /// Use **sha512** algorithm to generate **256** bytes length machine code
  String get sha512 {
    final machineCode = _generateMachineCode();
    final hashed = crypto.sha512.convert(utf8.encode(machineCode)).toString();
    debugPrint(hashed);
    return hashed;
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
    String os = Platform.operatingSystem;
    String cpu = _strategy.getCPUInfo();
    String disk = _strategy.getDiskSerialNumber();
    String mac = _strategy.getMacAddress();
    String memory = _strategy.getMemoryInfo();
    final machineCode = ['os@$os', cpu, disk, mac, memory, 'salt@$salt']
        .join('#')
        .replaceAll(' ', '_')
        .toUpperCase();
    return machineCode;
  }
}
