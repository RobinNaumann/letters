import 'package:elbe/elbe.dart';
import 'package:letters/errors/elbe_error.dart';

class ElbeErrorPage extends StatelessWidget {
  final ElbeError error;
  const ElbeErrorPage({super.key, required this.error});

  static void show(BuildContext context, ElbeError error) =>
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ElbeErrorPage(error: error)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      title: "error details",
      leadingIcon: LeadingIcon.none(),
      actions: [
        IconButton.integrated(
          icon: Icons.x,
          onTap: () => Navigator.of(context).pop(),
        )
      ],
      children: [
        _ErrorSnippet(error: error),
        Padded.only(top: .5, child: Text.h5("Cause Chain")),
        for (final cause in error.causeChain.skip(1))
          _ErrorSnippet(error: cause),
      ].spaced(),
    );
  }
}

class _ErrorSnippet extends StatelessWidget {
  final ElbeError error;
  const _ErrorSnippet({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
            children: [
          Text.code(error.code),
          Expanded(child: Text(error.message, textAlign: TextAlign.end)),
        ].spaced()),
        if (error.details != null) Text.code(error.details.toString())
      ].spaced(),
    ));
  }
}
