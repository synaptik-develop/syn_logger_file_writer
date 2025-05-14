import 'package:stack_trace/stack_trace.dart';
import 'package:syn_log_interface/syn_log_interface.dart';

/// Default [LogFormatter] for console output.
///
/// Split string into multiline, prettify output.
class FileFormatter implements LogFormatter {
  /// Default `const` constructor.
  const FileFormatter();
  static const _space = '  ';
  @override
  String format(LogEvent event) {
    final builder =
        StringBuffer()
          ..write('[${event.sourceName}]')
          ..write(_space);
    if (event.isolateDebugName != null) {
      builder
        ..write(event.isolateDebugName)
        ..write(_space);
    }
    builder
      ..writeAll([formatTime(event.time), formatLevel(event.level)], _space)
      ..write(_space)
      ..write(event.message);
    if (event.stackTrace != null) {
      builder.writeAll([
        '\nStackTrace\n',
        formatStackTrace(event.stackTrace).toString(),
      ]);
    }
    builder.write('\n');
    return builder.toString();
  }

  String formatTime(DateTime time) => time.toIso8601String();

  StackTrace? formatStackTrace(StackTrace? trace) =>
      trace != null ? Trace.from(trace).terse : null;

  String formatLevel(LogLevel level) => switch (level) {
    LogLevel.verbose => '[V]',
    LogLevel.debug => '[D]',
    LogLevel.info => '[I]',
    LogLevel.warning => '[W]',
    LogLevel.error => '[E]',
    LogLevel.fatal => '[F]',
  };
}
