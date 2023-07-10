import 'dart:io';

abstract class MachineCodeStrategy {
  String getDiskUUID();
}

class LinuxMachineCodeStrategy implements MachineCodeStrategy {
  @override
  String getDiskUUID() {
    ProcessResult result = Process.runSync('blkid', ['-s', 'UUID']);
    return result.stdout
        .toString()
        .split('UUID=')
        .last
        .replaceAll('"', '')
        .trim();
  }
}

class MacMachineCodeStrategy implements MachineCodeStrategy {
  @override
  String getDiskUUID() {
    ProcessResult result = Process.runSync(
      'system_profiler',
      ['SPStorageDataType'],
    );
    String disk = result.stdout.toString();
    return RegExp(r'Volume UUID: (.+)').firstMatch(disk)?.group(1) ?? '';
  }
}

class WindowsMachineCodeStrategy implements MachineCodeStrategy {
  @override
  String getDiskUUID() {
    ProcessResult result = Process.runSync(
      'wmic',
      ['diskdrive', 'get', 'serialnumber'],
    );
    return result.stdout.toString().trim().split('\n')[1].trim();
  }
}
