import 'package:elbe/elbe.dart';
import 'package:letters/model/m_font.dart';

typedef FilterState = ({
  FontsFilter filter,
  List<FontFamilyModel> fonts,
});

class FontsFilter {
  final String query;
  final String? style;
  final bool grid;
  final bool onlyInstalled;

  FontsFilter(
      {required this.query,
      required this.style,
      required this.grid,
      required this.onlyInstalled});

  FontsFilter copyWith(
          {String? query,
          String? Function()? style,
          bool? grid,
          bool? onlyInstalled}) =>
      FontsFilter(
        query: query ?? this.query,
        style: style != null ? style() : this.style,
        grid: grid ?? this.grid,
        onlyInstalled: onlyInstalled ?? this.onlyInstalled,
      );
}

class FontsFilterBit extends MapMsgBitControl<FilterState> {
  final List<FontFamilyModel> allFonts;
  final List<String> installedFontNames;
  static const builder = MapMsgBitBuilder<FilterState, FontsFilterBit>.make;

  FontsFilterBit(this.allFonts, this.installedFontNames)
      : super.worker((_) => (
              fonts: allFonts,
              filter: FontsFilter(
                  query: "", style: null, grid: true, onlyInstalled: false)
            ));

  FilterState _getState(FontsFilter filter) {
    final query = filter.query.toLowerCase();

    return (
      filter: filter,
      fonts: allFonts.where((f) {
        if (filter.onlyInstalled) {
          if (!installedFontNames.contains(f.id)) return false;
        }

        if (filter.style != null) {
          if (f.category != filter.style) return false;
        }

        if (filter.query.isNotEmpty) {
          if (!f.name.toLowerCase().contains(query)) return false;
        }

        return true;
      }).toList()
    );
  }

  void setGrid(bool isGrid) =>
      act((d) => _getState(d.filter.copyWith(grid: isGrid)));

  void setStyle(String? style) =>
      act((d) => _getState(d.filter.copyWith(style: () => style)));

  void setInstalled(bool isInstalled) =>
      act((d) => _getState(d.filter.copyWith(onlyInstalled: isInstalled)));

  void setQuery(String query) =>
      act((d) => _getState(d.filter.copyWith(query: query)));
}
