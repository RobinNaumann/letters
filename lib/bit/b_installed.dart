import 'dart:io';

import 'package:elbe/elbe.dart';
import 'package:letters/service/s_google_fonts.dart';
import 'package:moewe/moewe.dart';

const fontDir = "Library/Fonts";

String _fileId(String fontId) =>
    "letters_${fontId.toLowerCase().replaceAll(" ", "-")}";

class InstalledBit extends MapMsgBitControl<List<String>> {
  static const builder = MapMsgBitBuilder<List<String>, InstalledBit>.make;

  InstalledBit()
      : super.worker((_) async =>
            (await Process.run("atsutil", ["fonts", "-list"]))
                .stdout
                .toString()
                .split("\n")
                .map((f) => f.trim())
                .toList());

  Future<void> install(String id) async {
    moewe.event("font_install", data: {"id": id});
    final urls = await FontService.i.ttfUrls(id);
    await FontService.i
        .installFonts(urls, (i) => "../$fontDir/${_fileId(id)}_$i.ttf");

    await _waitAndReload();
  }

  Future<void> uninstall(String id) async {
    moewe.event("font_remove", data: {"id": id});
    // check if files exist
    final home = Directory.current.path;
    final files = Directory("$home/$fontDir")
        .listSync()
        .whereType<File>()
        .where((f) => f.path.split("/").last.startsWith(_fileId(id)))
        .toList();

    if (files.isEmpty) throw "Files not found";
    for (final file in files) {
      await file.delete();
    }
    await _waitAndReload();
  }

  void openFontBookApp() => Process.run("open", ["-a", "Font Book"]);
  Future _waitAndReload() async {
    await Future.delayed(Duration(seconds: 1));
    reload(silent: true);
    await Future.delayed(Duration(seconds: 1));
  }
}
