# Machine Code

Generating machine codes of different lengths through a series of computer-assisted information.

## Install

```bash
flutter pub add machine_code
```

## Getting started

```dart
import 'package:machine_code/machine_code.dart';

void main() {
  final code = MachineCode();
  code.md5.length;
  code.sha256.length;
  code.sha384.length;
  code.sha512.length;
}

```
