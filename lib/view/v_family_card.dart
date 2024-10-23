import 'package:elbe/elbe.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '../bit/b_installed.dart';
import '../model/m_font.dart';
import '../service/s_google_fonts.dart';
import 'v_explore.dart';
import 'v_family.dart';

class FamilyCard extends StatelessWidget {
  final FontFamilyModel family;
  final bool wide;
  final String text;
  const FamilyCard({
    super.key,
    required this.family,
    required this.wide,
    required this.text,
  });

  Widget maybeAspect({required Widget child}) =>
      wide ? Expanded(child: child) : AspectRatio(aspectRatio: 1, child: child);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        maybeAspect(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => FamilyPage(family: family)));
              },
              child: Container(
                  decoration: macosBoxDeco(context),
                  child: Stack(
                    alignment: wide ? Alignment.centerLeft : Alignment.center,
                    children: [
                      InstalledBit.builder(
                          onData: (bit, data) => data.contains(family.id)
                              ? Container(
                                  padding: EdgeInsets.all(8),
                                  alignment: Alignment.topRight,
                                  child: WIcon(
                                    CupertinoIcons.checkmark_alt_circle,
                                    color: MacosTheme.of(context)
                                        .typography
                                        .body
                                        .color
                                        ?.withOpacity(.2),
                                  ))
                              : Container()),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding:
                            wide ? EdgeInsets.symmetric(horizontal: 16) : null,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            WText(text,
                                //fonts[index].displayName ?? fonts[index].id,
                                style: FontService.i
                                    .getStyle(family.id, size: 48)),
                          ],
                        ),
                      ),
                    ],
                  ))),
        ),
        Spaced.vertical(.5),
        Hero(
            tag: fontHeroTag(family),
            child: WText(
              family.name,
              style: MacosTheme.of(context).typography.body.copyWith(
                  //fontWeight: wide ? FontWeight.bold : FontWeight.normal,
                  ),
              textAlign: wide ? TextAlign.start : TextAlign.center,
            )),
      ],
    );
  }
}
