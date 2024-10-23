import 'package:elbe/elbe.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '../bit/b_installed.dart';
import '../model/m_font.dart';

class InstallBtn extends StatefulWidget {
  final FontFamilyModel family;
  const InstallBtn({super.key, required this.family});

  @override
  State<InstallBtn> createState() => _InstallBtnState();
}

class _InstallBtnState extends State<InstallBtn> {
  bool _loading = false;

  void loading(bool value) => setState(() => _loading = value);

  void uninstall(InstalledBit bit) async {
    loading(true);
    try {
      await bit.uninstall(widget.family.id);
    } catch (e) {
      if (!mounted) return;
      showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
              horizontalActions: false,
              appIcon: WIcon(CupertinoIcons.exclamationmark_triangle),
              title: WText("could not remove Font"),
              message: WText(
                "Fonts not installed via Letters can only be removed via the MacOS Font Book App",
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              primaryButton: PushButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    bit.openFontBookApp();
                  },
                  controlSize: ControlSize.large,
                  child: WText("open Font Book")),
              secondaryButton: PushButton(
                  onPressed: () => Navigator.of(context).pop(),
                  controlSize: ControlSize.large,
                  secondary: true,
                  child: WText("okay"))));
    }
    loading(false);
  }

  void install(InstalledBit bit) async {
    loading(true);
    try {
      await bit.install(widget.family.id);
    } catch (e) {
      if (!mounted) return;
      showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
              appIcon: WIcon(CupertinoIcons.exclamationmark_triangle),
              title: WText("could not install Font"),
              message: WText(
                "make sure you are \nconnected to the internet",
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              primaryButton: PushButton(
                  onPressed: () => Navigator.of(context).pop(),
                  controlSize: ControlSize.large,
                  child: WText("okay"))));
    }
    loading(false);
  }

  @override
  Widget build(BuildContext context) {
    return InstalledBit.builder(
        onData: (bit, data) => _loading
            ? CupertinoActivityIndicator()
            : data.contains(widget.family.id)
                ? PushButton(
                    secondary: true,
                    controlSize: ControlSize.large,
                    onPressed: () => uninstall(bit),
                    child: WText("remove"))
                : PushButton(
                    controlSize: ControlSize.large,
                    onPressed: () => install(bit),
                    child: WText("install"),
                  ));
  }
}
