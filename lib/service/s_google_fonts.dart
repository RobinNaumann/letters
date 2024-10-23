import 'dart:convert';

import 'package:elbe/util/json_tools.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:letters/model/m_font.dart';

class MetaFile {
  final String? name;
  final String? content;
  const MetaFile(this.name, this.content);
}

const String allLettersSentense = "A quick brown fox jumps over the lazy dog";

FontWeight _fromInt(int? weight) {
  if (weight == null) return FontWeight.normal;
  if (weight <= 100) return FontWeight.w100;
  if (weight <= 200) return FontWeight.w200;
  if (weight <= 300) return FontWeight.w300;
  if (weight <= 400) return FontWeight.w400;
  if (weight <= 500) return FontWeight.w500;
  if (weight <= 600) return FontWeight.w600;
  if (weight <= 700) return FontWeight.w700;
  if (weight <= 800) return FontWeight.w800;
  if (weight <= 900) return FontWeight.w900;
  return FontWeight.normal;
}

abstract class FontService {
  static final i = GoogleFontsService();

  Future<List<FontFamilyModel>> getFamilies();

  TextStyle getStyle(String id, {int? weight, bool? italic, double? size}) {
    final fW = _fromInt(weight);
    TextStyle style = TextStyle(fontWeight: fW);

    try {
      style = GoogleFonts.getFont(
        id.replaceAll(" ", " "),
        fontWeight: fW,
      );
    } catch (e) {}
    return style.copyWith(
      fontSize: size,
      fontStyle: italic ?? false ? FontStyle.italic : FontStyle.normal,
    );
  }

  Future<List<String>> ttfUrls(String fontId);

  Future<List<MetaFile>> fontMeta(String fontId);

  Future<void> installFonts(
      List<String> urls, String Function(int id) name) async {
    for (int i = 0; i < urls.length; i++) {
      await FileSaver.instance
          .saveFile(name: name(i), link: LinkDetails(link: urls[i]));
    }
  }
}

class GoogleFontsService extends FontService {
  @override
  Future<List<FontFamilyModel>> getFamilies() async {
    const url = 'https://fonts.google.com/metadata/fonts';

    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) throw Exception('Failed to load fonts');

    final JsonMap json = jsonDecode(res.body);

    return json
        .asCast<List>("familyMetadataList")
        .map((e) => _parseFamilyGoogle(e))
        .toList();
  }

  Future<JsonMap> _getMeta(String fontId) async {
    final url = "https://fonts.google.com/download/list?family=$fontId";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) throw Exception('Failed to load fonts');

    return jsonDecode(res.body.substring(5));
  }

  @override
  Future<List<String>> ttfUrls(String fontId) async {
    return (await _getMeta(fontId))
            .maybeCast<JsonMap>("manifest")
            ?.maybeCast<List>("fileRefs")
            ?.map((e) => "${e["url"]}")
            .toList() ??
        [];
  }

  @override
  Future<List<MetaFile>> fontMeta(String fontId) async {
    return (await _getMeta(fontId))
            .maybeCast<JsonMap>("manifest")
            ?.maybeCast<List>("files")
            ?.map((e) => MetaFile(e["filename"], e["contents"]))
            .toList() ??
        [];
  }
}

FontFamilyModel _parseFamilyGoogle(JsonMap m) => FontFamilyModel(
      id: m.get("family"),
      displayName: m.maybeCast("DisplayName"),
      category: m.maybeCast("category"),
      stroke: m.maybeCast("stroke"),
      isOpenSource: m.maybeCast("isOpenSource"),
      designers: m.maybeCastList<String>("designers"),
      classification: m.maybeCastList<String>("classifications") ?? [],
      updated: m.maybeCast("updated"),
      popularity: m.maybeCast("popularity"),
      source: "Google Fonts",
      url: "https://fonts.google.com/specimen/${m.get("family")}",
      fonts: m
          .asCast<JsonMap>("fonts")
          .entries
          .map(
            (e) => _parseFontGoogle(e.key, e.value),
          )
          .toList(),
    );

FontModel _parseFontGoogle(String id, JsonMap m) => FontModel(
      id: id,
      thickness: m.maybeCast("thickness"),
      slant: m.maybeCast("slant"),
      width: m.maybeCast("width"),
      lineHeight: m.maybeCast("lineHeight"),
    );
