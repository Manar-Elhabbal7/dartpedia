import 'dart:io';

const String ansiEscape = '\x1B';

Future<void> write(String text, {int duration = 50}) async {
  List<String> lines = text.split('\n');
  for (var line in lines) {
    for (var char in line.split('')) {
      await _delayedPrint(char, duration);
    }
  }
}

Future<void> _delayedPrint(String char, int duration) async {
  return Future.delayed(Duration(milliseconds: duration), () {
    stdout.write(char);
  });
}

enum Colors {
  lightBlue(184, 234, 254),
  red(242, 93, 80),
  yellow(249, 248, 196),
  grey(240, 240, 240),
  white(255, 255, 255);

  const Colors(this.r, this.g, this.b);

  final int r;
  final int g;
  final int b;

  String get enableForeground => '$ansiEscape[38;2;$r;$g;${b}m';

  String get enableBackground => '$ansiEscape[48;2;$r;$g;${b}m';
  static String get reset => '$ansiEscape[0m';

  String applyForeground(String text) {
    return '$ansiEscape[38;2;$r;$g;${b}m$text$reset';
  }

  String applyBackground(String text) {
    return '$ansiEscape[48;2;$r;$g;${b}m$text$ansiEscape[0m';
  }
}

extension TextRender on String {
  String get errorText => Colors.red.applyForeground(this);
  String get instructionText => Colors.yellow.applyForeground(this);
  String get titleText => Colors.lightBlue.applyForeground(this);

  List<String> splitLinesByLength(int length) {
    final List<String> words = split(' ');
    final List<String> output = <String>[];
    final StringBuffer strBuffer = StringBuffer();

    for (int i = 0; i < words.length; i++) {
      final String word = words[i];
      if (strBuffer.length + word.length + 1 > length) {
        strBuffer.write(word.trim());
        if (strBuffer.length + 1 <= length) {
          strBuffer.write(' ');
        }
      }
      if (i + 1 < words.length &&
          words[i + 1].length + strBuffer.length + 1 > length) {
        output.add(strBuffer.toString().trim());
        strBuffer.clear();
      }
    }
    output.add(strBuffer.toString().trim());
    return output;
  }
}
