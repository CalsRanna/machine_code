import 'dart:io';

abstract class MachineCodeStrategy {
  String getCPUInfo();
  String getDiskSerialNumber();
  String getMacAddress();
  String getMemoryInfo();
}

class LinuxMachineCodeStrategy implements MachineCodeStrategy {
  @override
  String getCPUInfo() {
    ProcessResult result = Process.runSync('cat', ['/proc/cpuinfo']);
    String cpu =
        result.stdout.toString().trim().split('\n')[4].split(':')[1].trim();
    return 'cpu@$cpu';
  }

  @override
  String getDiskSerialNumber() {
    ProcessResult result = Process.runSync(
      'lsblk',
      ['-no', 'serial', '/dev/sda'],
    );
    String disk = result.stdout.toString().trim();
    return 'volume uuid@$disk';
  }

  @override
  String getMacAddress() {
    ProcessResult result = Process.runSync('ip', ['link', 'show']);
    String mac = RegExp(r'link/ether ([\w:]+) ')
            .firstMatch(result.stdout.toString())
            ?.group(1) ??
        '';
    return 'mac@$mac';
  }

  @override
  String getMemoryInfo() {
    ProcessResult result = Process.runSync('cat', ['/proc/meminfo']);
    String memory = result.stdout.toString();
    List<String> memories = memory.split('\n');
    int total = int.parse(memories[0].split(':')[1].trim().split(' ')[0]);
    return 'memory@$total';
  }
}

class MacMachineCodeStrategy implements MachineCodeStrategy {
  @override
  String getCPUInfo() {
    ProcessResult result = Process.runSync(
      '/usr/sbin/sysctl',
      ['machdep.cpu.brand_string'],
    );
    String cpu = result.stdout.toString().split(': ')[1].trim();
    return 'cpu@$cpu';
  }

  @override
  String getDiskSerialNumber() {
    ProcessResult result = Process.runSync(
      'system_profiler',
      ['SPStorageDataType'],
    );
    String disk = result.stdout.toString();
    String volumeUUID =
        RegExp(r'Volume UUID: (.+)').firstMatch(disk)?.group(1) ?? '';
    return 'volume uuid@$volumeUUID';
  }

  @override
  String getMacAddress() {
    ProcessResult result = Process.runSync('ifconfig', []);
    String mac = result.stdout
        .toString()
        .split('en0: flags=')[1]
        .split('ether ')[1]
        .split(' ')[0]
        .trim();
    return 'mac@$mac';
  }

  @override
  String getMemoryInfo() {
    ProcessResult result = Process.runSync(
      'sysctl',
      ['-n', 'hw.memsize'],
    );
    String memory = result.stdout.toString().trim();
    return 'memory@$memory';
  }
}

class WindowsMachineCodeStrategy implements MachineCodeStrategy {
  @override
  String getCPUInfo() {
    ProcessResult result = Process.runSync('wmic', ['cpu', 'get', 'name']);
    String cpu = result.stdout.toString().trim().split('\n')[1].trim();
    return 'cpu@$cpu';
  }

  @override
  String getDiskSerialNumber() {
    ProcessResult result = Process.runSync(
      'wmic',
      ['diskdrive', 'get', 'serialnumber'],
    );
    String disk = result.stdout.toString().trim().split('\n')[1].trim();
    return 'volume uuid@$disk';
  }

  @override
  String getMacAddress() {
    ProcessResult result = Process.runSync('getmac', []);
    String mac =
        result.stdout.toString().trim().split('\n')[3].split(' ')[0].trim();
    return 'mac@$mac';
  }

  @override
  String getMemoryInfo() {
    ProcessResult result = Process.runSync(
      'wmic',
      ['memorychip', 'get', 'capacity'],
    );
    String memory = result.stdout.toString().trim().split('\n')[1];
    List<String> memories = memory.split('  ');
    memories.removeWhere((element) => element.isEmpty);
    int sum = 0;
    for (String m in memories) {
      sum += int.parse(m.trim());
    }
    return 'memory@$sum';
  }
}
