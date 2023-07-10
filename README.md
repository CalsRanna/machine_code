# Machine Code

![Current Version](https://img.shields.io/badge/0.0.5-blue?style=flat-square&label=version)

Generating machine codes of different lengths through hard drive's uuid and salt.

## Install

```bash
flutter pub add machine_code
```

## Getting started

```dart
import 'package:machine_code/machine_code.dart';

void main() {
  final code = MachineCode();
  print(code.md5);
  print(code.sha256);
  print(code.sha384);
  print(code.sha512);
}

```
