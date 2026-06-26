import 'dart:collection';
import 'arguments.dart';
import 'dart:async';
import 'exceptions.dart';

class CommandRunner {
  final String executableName;
  final String description;
  CommandRunner(
    this.executableName,
    this.description, {
    this.onError,
    this.onOutput,
  });
  final Map<String, Command> _commands = <String, Command>{};

  UnmodifiableSetView<Command> get commands =>
      UnmodifiableSetView<Command>(<Command>{..._commands.values});

  FutureOr<void> Function(String)? onOutput;
  FutureOr<void> Function(Object)? onError;

  String get usage => '$executableName: $description';

  Future<void> run(List<String> input) async {
    try {
      final ArgResults results = parse(input);
      if (results.command != null) {
        Object? output = await results.command!.run(results);
        if (onOutput != null) {
          await onOutput!(output.toString());
        } else {
          print(output.toString());
        }
      }
    } on Exception catch (exception) {
      if (onError != null) {
        onError!(exception);
      } else {
        rethrow;
      }
    }
  }

  void addCommand(Command command) {
    _commands[command.name] = command;
    command.runner = this;
  }

  ArgResults parse(List<String> input) {
    ArgResults results = ArgResults();
    if (input.isEmpty) return results;

    //handle unknown command
    if (_commands.containsKey(input.first)) {
      results.command = _commands[input.first];
      input = input.sublist(1);
    } else {
      throw ArgumentException(
        'The first word of input must be a command.',
        null,
        input.first,
      );
    }

    //handle multiple commands
    if (input.isNotEmpty && _commands.containsKey(input.first)) {
      throw ArgumentException(
        'Commands can only have up to one command.',
        results.command!.name,
        input.first,
      );
    }

    Map<Option, Object?> inputOptions = {};
    int i = 0;

    //parse options and arguments
    while (i < input.length) {
      if (input[i].startsWith('-')) {
        var base = _removeDash(input[i]);

        //handle unknown option
        var option = results.command!.options.firstWhere(
          (option) => option.name == base || option.abbr == base,
          orElse: () {
            throw ArgumentException(
              'Unknown option ${input[i]}',
              results.command!.name,
              input[i],
            );
          },
        );
        //handle option types
        if (option.type == OptionType.flag) {
          inputOptions[option] = true;
          i++;
          continue;
        }

        //handle option with argument
        if (option.type == OptionType.option) {
          if (i + 1 >= input.length) {
            throw ArgumentException(
              'Option ${option.name} requires an argument',
              results.command!.name,
              option.name,
            );
          }

          if (input[i + 1].startsWith('-')) {
            throw ArgumentException(
              'Option ${option.name} requires an argument, but got another option ${input[i + 1]}',
              results.command!.name,
              option.name,
            );
          }
          var arg = input[i + 1];
          inputOptions[option] = arg;
          i++;
        }
      } else {
        //handle multiple arguments
        if (results.commandArg != null && results.commandArg!.isNotEmpty) {
          throw ArgumentException(
            'Commands can only have up to one argument.',
            results.command!.name,
            input[i],
          );
        }
        results.commandArg = input[i];
      }
      i++;
    }
    results.options = inputOptions;

    return results;
  }

  String _removeDash(String input) {
    if (input.startsWith('--')) {
      return input.substring(2);
    }
    if (input.startsWith('-')) {
      return input.substring(1);
    }
    return input;
  }
}
