typedef UnixMS = int;

class FontFamilyModel {
  final String id;
  final String? displayName;

  final String category;
  final List<String> classification;
  final String? stroke;
  final bool? isOpenSource;

  final List<String>? designers;
  final UnixMS? updated;
  final int? popularity;
  final String? source;
  final String? url;

  final List<FontModel> fonts;

  String get name => displayName ?? id;

  const FontFamilyModel({
    required this.id,
    this.displayName,
    required this.category,
    required this.classification,
    required this.stroke,
    required this.isOpenSource,
    required this.designers,
    required this.updated,
    this.popularity,
    this.source,
    this.url,
    required this.fonts,
  });
}

class FontModel {
  final String id;
  final int? thickness;
  final int? slant;
  final int? width;
  final double? lineHeight;

  int get weight => int.tryParse(id.substring(0, 3)) ?? thickness ?? 400;
  bool get italic => id.endsWith("i"); //(slant ?? 0) > 0 || id.endsWith("i");

  const FontModel({
    required this.id,
    required this.thickness,
    required this.slant,
    required this.width,
    required this.lineHeight,
  });
}
