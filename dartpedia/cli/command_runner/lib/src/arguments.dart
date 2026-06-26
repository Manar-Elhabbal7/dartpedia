import '../command_runner.dart';
import 'dart:collection';
import 'dart:async';

enum OptionType { flag, option }

abstract class Argument {
  String get name;
  String? get help;

  Object? get defaultValue;
  String? get helpHint;

  String get usage;
}

class Option extends Argument {
  Option(
    //positional parameter
    this.name, {
    //named parameters
    required this.type,
    this.help,
    this.abbr,
    this.defaultValue,
    this.helpHint,
  });

  final String? abbr;
  final OptionType type;

  //@override -> to show i implemented the method from the abstract class
  @override
  final String name;

  @override
  final String? help;

  @override
  final Object? defaultValue;

  @override
  final String? helpHint;

  @override
  String get usage {
    if (abbr != null) {
      return '-$abbr,--$name: $help';
    }

    return '--$name: $help';
  }
}

abstract class Command extends Argument {
  @override
  String get name;

  @override
  String? help;

  @override
  String? defaultValue;

  @override
  String? helpHint;

  String get description;
  bool get requiresArgument => false;
  late CommandRunner runner;

  final List<Option> _options = [];
  UnmodifiableSetView<Option> get options =>
      UnmodifiableSetView(_options.toSet());

  void addFlag(String name, {String? help, String? abbr, String? helpHint}) {
    _options.add(
      Option(
        name,
        help: help,
        abbr: abbr,
        defaultValue: false,
        helpHint: helpHint,
        type: OptionType.flag,
      ),
    );
  }

  void addOption(
    String name, {
    String? help,
    String? abbr,
    String? defaultValue,
    String? helpHint,
  }) {
    _options.add(
      Option(
        name,
        help: help,
        abbr: abbr,
        defaultValue: defaultValue,
        helpHint: helpHint,
        type: OptionType.option,
      ),
    );
  }

  FutureOr<Object?> run(ArgResults args);

  @override
  String get usage {
    return '$name:  $description';
  }
}

class ArgResults {
  Command? command;
  String? commandArg;
  Map<Option, Object?> options = {};

  bool flag(String name) {
    for (var option in options.keys.where(
      (option) => option.type == OptionType.flag,
    )) {
      if (option.name == name) {
        return options[option] as bool;
      }
    }
    return false;
  }

  bool hasOption(String name) {
    return options.keys.any((option) => option.name == name);
  }

  (Option option, Object? input) getOption(String name) {
    var mapEntry = options.entries.firstWhere(
      (entry) => entry.key.name == name || entry.key.abbr == name,
    );

    return (mapEntry.key, mapEntry.value);
  }
}
