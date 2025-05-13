import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'package:syn_log_interface/syn_log_interface.dart';
import 'package:syn_logger_file_writer/src/file_formatter.dart';

/// Default [LogWriter] for write into file in selected directory.
class FileWriter implements LogWriter {
  FileWriter({required Directory logDirectory, String? fileNamePrefix})
    : _logDirectory = logDirectory,
      _fileNamePrefix = fileNamePrefix;

  final String? _fileNamePrefix;
  final Directory _logDirectory;

  final _fileNameFormatter = DateFormat('yyyy-MM-ddTHH.mm.ss.mmm');

  @override
  final formatter = FileFormatter();

  IOSink? _fileSink;

  @override
  Future<void> write(LogEvent event) async {
    _fileSink ??= _createFileAndOpenToWrite();
    final message = utf8.encode(formatter.format(event));

    _fileSink!.add(message);
  }

  String _generateLogFileName() {
    final now = _fileNameFormatter.format(DateTime.now());
    return '${_fileNamePrefix ?? ""}$now.log';
  }

  IOSink _createFileAndOpenToWrite() =>
      File(join(_logDirectory.path, _generateLogFileName())).openWrite();
}
