import 'package:elbe/elbe.dart';
import 'package:flutter/cupertino.dart';
import 'package:letters/bit/b_filter.dart';
import 'package:letters/bit/b_fonts.dart';
import 'package:letters/model/m_font.dart';
import 'package:letters/view/v_filters.dart';
import 'package:macos_ui/macos_ui.dart';

import '../bit/b_installed.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return InstalledBit.builder(
        onData: (_, installed) => FontsBit.builder(
            onData: (_, allFonts) => BitProvider(
                create: (context) => FontsFilterBit(allFonts, installed),
                child: FontsFilterBit.builder(
                  onData: (filterBit, filter) => MacosScaffold(
                    toolBar: ToolBar(
                      titleWidth: 90,
                      title: WText(
                        'Letters',
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                      actions: [
                        ToolBarIconButton(
                            label: "view",
                            icon: MacosIcon(filter.filter.grid
                                ? CupertinoIcons.rectangle_grid_1x2
                                : CupertinoIcons.square_grid_2x2),
                            tooltipMessage: "toggle grid/list view",
                            onPressed: () =>
                                filterBit.setGrid(!filter.filter.grid),
                            showLabel: false),
                        ToolBarDivider(),
                        ToolBarIconButton(
                            tooltipMessage: "only show installed fonts",
                            label: "only installed",
                            onPressed: () => filterBit
                                .setInstalled(!filter.filter.onlyInstalled),
                            icon: MacosIcon(
                              filter.filter.onlyInstalled
                                  ? CupertinoIcons.check_mark_circled_solid
                                  : CupertinoIcons.check_mark_circled,
                            ),
                            showLabel: false),
                        ToolBarPullDownButton(
                            label: "font style",
                            icon: filter.filter.style != null
                                ? CupertinoIcons.paintbrush_fill
                                : CupertinoIcons.paintbrush,
                            items: [
                              MacosPulldownMenuItem(
                                label: "all",
                                title: WText("all"),
                                onTap: () => filterBit.setStyle(null),
                              ),
                              MacosPulldownMenuDivider(),
                              ...allFonts.fold<Set<String>>(
                                  {},
                                  (prev, f) =>
                                      prev..add(f.category)).map((c) =>
                                  MacosPulldownMenuItem(
                                      label: c,
                                      title: WText(c),
                                      onTap: () => filterBit.setStyle(c))),
                            ]),
                        ToolBarSpacer(spacerUnits: .125),
                        CustomToolbarItem(
                            inOverflowedBuilder: (_) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: WText(
                                    "expand window for advanced filters",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            inToolbarBuilder: (_) => SizedBox(
                                width: 160,
                                child: MacosSearchField(
                                    onChanged: (query) =>
                                        filterBit.setQuery(query)))),
                      ],
                    ),
                    children: [
                      ContentArea(
                          builder: ((_, c) =>
                              FontsFilteredList(controller: c))),
                    ],
                  ),
                ))));
  }
}

String fontHeroTag(FontFamilyModel f) => "font_${f.id}";
