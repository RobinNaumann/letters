import 'dart:io';

import 'package:elbe/elbe.dart';
import 'package:letters/errors/elbe_error.dart';
import 'package:letters/errors/elbe_errors.dart';
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
    try {
      moewe.event("font_install", data: {"id": id});
      final urls = await FontService.i.ttfUrls(id);
      await FontService.i
          .installFonts(urls, (i) => "../$fontDir/${_fileId(id)}_$i.ttf");
      await _waitAndReload(urls.length);
    } catch (e) {
      throw ElbeError("INSTALL", "could not install font");
    }
  }

  Future<void> uninstall(String id) async {
    try {
      moewe.event("font_remove", data: {"id": id});
      // check if files exist
      final home = (() => Platform.environment['HOME'])
          .zoned(ElbeError.make("GET_HOME", "could not find home"));

      final files = (() => Directory("$home/$fontDir")
              .listSync()
              .whereType<File>()
              .where((f) => f.path.split("/").last.startsWith(_fileId(id)))
              .toList())
          .zoned(ElbeError.make("FONT_LIST", "could not load font files"));

      if (files.isEmpty) {
        throw ElbeError("NO_FILES", "font not found", {
          "home": home,
          "fontDir": "$home/$fontDir",
          "allFiles": Directory("$home/$fontDir").listSync()
        });
      }
      for (final file in files) {
        await file.delete();
      }
      await _waitAndReload(files.length);
    } catch (e) {
      throw ElbeError("UNINST", "could not remove font", e);
    }
  }

  void openFontBookApp() => Process.run("open", ["-a", "Font Book"]);
  Future _waitAndReload([int length = 1]) async {
    await Future.delayed(Duration(seconds: length.clamp(3, 8)));
    reload(silent: true);
    await Future.delayed(Duration(seconds: 1));
  }
}
