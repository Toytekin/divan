import 'package:toplantid/modeller/grup_model.dart';

import '../modeller/kisi_model.dart';

abstract class BaseDB {
  void grupKayit(
      String id, String mahalleAdi, String resimYolu, List<KisiModel> kisiler);
}
