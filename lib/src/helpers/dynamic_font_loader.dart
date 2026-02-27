import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

class DynamicFontLoader {
  static final Set<String> _loadedFonts = {};
  static final Map<String, Future<void>> _loadingTasks = {};

  static Future<void>? _zipExtractTask;

  /// Set to true in widget tests to bypass actual font loading
  static bool isTestMode = false;

  static Future<void> loadFont(int pageNumber) async {
    if (isTestMode) return;

    final fontName = 'QCF_P${pageNumber.toString().padLeft(3, '0')}';

    if (_loadedFonts.contains(fontName)) return;

    if (_loadingTasks.containsKey(fontName)) {
      return _loadingTasks[fontName];
    }

    final task = _extractAndLoadFont(fontName);
    _loadingTasks[fontName] = task;

    try {
      await task;
      _loadedFonts.add(fontName);
    } finally {
      _loadingTasks.remove(fontName);
    }
  }

  static Future<void> _extractZipIfNeeded(Directory dir) async {
    if (_zipExtractTask != null) {
      return _zipExtractTask;
    }

    _zipExtractTask = _doExtractZip(dir);
    try {
      await _zipExtractTask;
    } catch (e) {
      _zipExtractTask = null;
      rethrow;
    }
  }

  static Future<void> _doExtractZip(Directory dir) async {
    // Load zip from assets bundle
    final byteData = await rootBundle.load(
      'packages/qcf_quran/assets/fonts/qcf4.zip',
    );
    final bytes = byteData.buffer.asUint8List();

    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      if (file.isFile && file.name.endsWith('.woff')) {
        final filename = file.name.split('/').last;
        final outFile = File('${dir.path}/$filename');
        await outFile.writeAsBytes(file.content as List<int>);
      }
    }
  }

  static Future<void> _extractAndLoadFont(String fontName) async {
    final dir = await getApplicationDocumentsDirectory();
    final pageStr = fontName.substring(5); // Extracts "001" from "QCF_P001"
    final fileName = 'QCF4${pageStr}_X-Regular.woff';
    final fontFile = File('${dir.path}/$fileName');

    if (!await fontFile.exists()) {
      await _extractZipIfNeeded(dir);
    }

    if (!await fontFile.exists()) {
      throw Exception(
        'Font file $fileName not found even after extracting zip',
      );
    }

    final fontLoader = FontLoader(fontName);
    fontLoader.addFont(_readFontFile(fontFile));
    await fontLoader.load();
  }

  static Future<ByteData> _readFontFile(File file) async {
    final bytes = await file.readAsBytes();
    return ByteData.view(bytes.buffer);
  }
}
