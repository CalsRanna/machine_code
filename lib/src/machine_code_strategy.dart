import 'dart:io';

abstract class MachineCodeStrategy {
  String getDiskUUID();
}

class LinuxMachineCodeStrategy implements MachineCodeStrategy {
  @override
  String getDiskUUID() {
    ProcessResult result = Process.runSync('blkid', ['-s']);
    final uuids = result.stdout.toString().split('\n');
    uuids.sort((a, b) => a.compareTo(b));
    return uuids.first
        .split('UUID=')
        .last
        .replaceAll('"', '')
        .toUpperCase()
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
