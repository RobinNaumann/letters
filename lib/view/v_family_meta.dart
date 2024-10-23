import 'package:elbe/elbe.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:letters/bit/b_font_meta.dart';
import 'package:letters/service/s_google_fonts.dart';
import 'package:macos_ui/macos_ui.dart';

import 'v_family.dart';

class FontMetaView extends StatelessWidget {
  final String fontId;
  const FontMetaView({super.key, required this.fontId});

  @override
  Widget build(BuildContext context) {
    return BitBuildProvider(
        create: (_) => FontMetaBit(fontId),
        onData: (bit, List<MetaFile> data) => Column(
              children: data.map((f) => _FileCard(file: f)).spaced(),
            ));
  }
}

class _FileCard extends StatelessWidget {
  final MetaFile file;
  const _FileCard({required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: macosBoxDeco(context),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MacosIcon(
                CupertinoIcons.doc,
                color: MacosTheme.of(context).typography.body.color,
              ),
              Expanded(child: WText(file.name ?? "unnamed file")),
            ].spaced(),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: WText(file.content ?? "no content",
                  style: GoogleFonts.spaceMono())),
        ].spaced(),
      ),
    );
  }
}
