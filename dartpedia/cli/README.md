# 💻 Dartpedia CLI Package

[![Dart](https://img.shields.io/badge/Dart-3.12%2B-blue.svg?logo=dart)](https://dart.dev)

This package contains the command-line application logic for **Dartpedia**. It binds the custom `command_runner` parser with the `wikipedia` API client package to expose search and article reading features directly on your terminal.

For full monorepo setup and architecture details, please refer to the [Root README](../README.md).

---

## 🚀 Quick Run

Make sure you've run `dart pub get` in the monorepo root. Then, run commands directly from this folder:

```bash
# Print usage help
dart run bin/cli.dart help

# Search Wikipedia
dart run bin/cli.dart search "Flutter"

# Get article summary
dart run bin/cli.dart article "Dart (programming language)"
```

---

## 📂 Structure

- `bin/cli.dart`: The CLI entry point where the CLI app is set up and executed.
- `lib/src/commands/`: Individual implementations for commands (`search`, `article`, etc.).
- `lib/src/logger.dart`: File logger utility configured to write events to the `logs/` subdirectory.
- `test/cli_test.dart`: Unit tests targeting CLI commands.
