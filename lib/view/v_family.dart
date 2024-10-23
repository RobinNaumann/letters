import 'package:elbe/elbe.dart';
import 'package:flutter/cupertino.dart';
import 'package:letters/service/s_google_fonts.dart';
import 'package:letters/view/v_family_meta.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/m_font.dart';
import 'v_explore.dart';
import 'v_install.dart';

BoxDecoration macosBoxDeco(BuildContext c) => BoxDecoration(
    color: MacosTheme.of(c).canvasColor,
    border: WBorder.all(color: MacosTheme.of(c).dividerColor),
    borderRadius: BorderRadius.circular(12));

class FamilyPage extends StatelessWidget {
  final FontFamilyModel family;
  const FamilyPage({super.key, required this.family});

  @override
  Widget build(BuildContext context) {
    final hStyle = MacosTheme.of(context).typography.headline;
    return MacosScaffold(
        toolBar: ToolBar(
          title: WText("font family"),
        ),
        children: [
          ContentArea(
              builder: (context, scrollController) => ListView(
                    padding: EdgeInsets.all(16),
                    controller: scrollController,
                    children: [
                      _FontOverview(family: family),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: _FontDetails(family: family),
                      ),
                      WText("Variants", style: hStyle),
                      for (var font in family.fonts)
                        _VariantCard(font: font, family: family),
                      Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: WText("Legal Information", style: hStyle)),
                      //AnimatedEnter(child: FontMetaView(fontId: family.id))
                      FontMetaView(fontId: family.id)
                    ].spaced(),
                  ))
        ]);
  }
}

class _FontDetails extends StatelessWidget {
  final FontFamilyModel family;
  const _FontDetails({super.key, required this.family});

  Widget _card(BuildContext c, IconData icon, String label, [String? link]) {
    return GestureDetector(
      onTap: () => link != null ? launchUrlString(link) : null,
      child: Container(
        decoration: macosBoxDeco(c),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WIcon(icon,
                color: MacosTheme.of(c).typography.body.color, size: 16),
            WText(label, style: MacosTheme.of(c).typography.body),
            if (link != null) MacosIcon(CupertinoIcons.link, size: 16)
          ].spaced(amount: .5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (family.designers?.isNotEmpty ?? false)
              _card(
                  context,
                  family.designers!.length > 1
                      ? CupertinoIcons.person_2
                      : CupertinoIcons.person,
                  family.designers!.join(", ")),
            _card(context, CupertinoIcons.tag, family.category),
            if (family.isOpenSource ?? false)
              _card(context, CupertinoIcons.star, "Open Source"),
            if (family.source != null)
              _card(context, CupertinoIcons.globe, "via ${family.source!}",
                  family.url),
            _card(context, CupertinoIcons.rectangle_on_rectangle_angled,
                "${family.fonts.length} variant${family.fonts.length > 1 ? "s" : ""}"),
          ].spaced(amount: .5),
        ));
  }
}

class _FontOverview extends StatelessWidget {
  final FontFamilyModel family;
  const _FontOverview({super.key, required this.family});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
                tag: fontHeroTag(family),
                child: WText(family.name,
                    style: MacosTheme.of(context).typography.largeTitle)),
          ],
        )),
        InstallBtn(family: family)
      ],
    );
  }
}

class _VariantCard extends StatelessWidget {
  final FontModel font;
  final FontFamilyModel family;
  const _VariantCard({super.key, required this.font, required this.family});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: macosBoxDeco(context),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: WText(allLettersSentense,
                  style: FontService.i.getStyle(family.id,
                      weight: font.weight, italic: font.italic, size: 34))),
          WText(
            font.id,
            style: MacosTheme.of(context).typography.caption1,
          ),
        ].spaced(),
      ),
    );
  }
}

class AnimatedEnter extends StatefulWidget {
  final Widget child;
  const AnimatedEnter({super.key, required this.child});

  @override
  State<AnimatedEnter> createState() => _AnimatedEnterState();
}

class _AnimatedEnterState extends State<AnimatedEnter> {
  bool visible = false;

  @override
  void initState() async {
    super.initState();
    await Future.delayed(Duration(milliseconds: 100));
    if (mounted) setState(() => visible = true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Durations.medium3,
      opacity: visible ? 1 : 0,
      child: widget.child,
    );
  }
}
