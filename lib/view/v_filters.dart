import 'package:elbe/elbe.dart';
import 'package:letters/bit/b_filter.dart';
import 'package:letters/service/s_google_fonts.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:moewe/moewe.dart';

import 'v_family_card.dart';

class FontsFilteredList extends StatefulWidget {
  final ScrollController? controller;
  const FontsFilteredList({super.key, this.controller});

  @override
  State<FontsFilteredList> createState() => _FontsFilteredListState();
}

class _FontsFilteredListState extends State<FontsFilteredList> {
  final TextEditingController _customCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FontsFilterBit.builder(
        onData: (bit, data) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MoeweUpdateView(
                  url: "https://apps.robbb.in/letters",
                ),
                if (!data.filter.grid)
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                          border: WBorder(
                              bottom: BorderSide(
                                  color: MacosTheme.of(context).dividerColor))),
                      child: MacosTextField.borderless(
                        controller: _customCtrl,
                        onChanged: (_) => setState(() {}),
                        placeholder: "enter custom text",
                      )),
                Expanded(
                  child: GridView.builder(
                      padding: EdgeInsets.all(16),
                      controller: widget.controller,
                      itemCount: data.fonts.length,
                      itemBuilder: (context, index) => FamilyCard(
                            family: data.fonts[index],
                            wide: !data.filter.grid,
                            text: data.filter.grid
                                ? "Aa"
                                : _customCtrl.text.isNotEmpty
                                    ? _customCtrl.text
                                    : allLettersSentense,
                          ),
                      gridDelegate: data.filter.grid
                          ? SliverGridDelegateWithMaxCrossAxisExtent(
                              childAspectRatio: .7,
                              maxCrossAxisExtent: 140,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16)
                          : SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 20,
                              mainAxisExtent: 110,
                              crossAxisCount: 1)),
                ),
              ],
            ));
  }
}
