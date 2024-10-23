import 'package:elbe/elbe.dart';
import 'package:letters/service/s_google_fonts.dart';

class FontMetaBit extends MapMsgBitControl<List<MetaFile>> {
  static const builder = MapMsgBitBuilder<List<MetaFile>, FontMetaBit>.make;

  FontMetaBit(String id) : super.worker((_) => FontService.i.fontMeta(id));
}
