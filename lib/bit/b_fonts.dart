import 'package:elbe/elbe.dart';
import 'package:letters/model/m_font.dart';
import 'package:letters/service/s_google_fonts.dart';

class FontsBit extends MapMsgBitControl<List<FontFamilyModel>> {
  static const builder = MapMsgBitBuilder<List<FontFamilyModel>, FontsBit>.make;

  FontsBit() : super.worker((_) async => await FontService.i.getFamilies());
}
