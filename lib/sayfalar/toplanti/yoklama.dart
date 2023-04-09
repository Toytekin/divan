import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../modeller/grup_model.dart';
import '../../modeller/kisi_model.dart';
import '../../modeller/yoklama_model.dart';

// ignore: must_be_immutable
class YoklamaSayfasi extends StatefulWidget {
  String toplatiID;
  String teskilatID;

  YoklamaSayfasi({
    super.key,
    required this.toplatiID,
    required this.teskilatID,
  });

  @override
  State<YoklamaSayfasi> createState() => _YoklamaSayfasiState();
}

class _YoklamaSayfasiState extends State<YoklamaSayfasi> {
  var boxYoklama = Hive.box<YoklamaModel>("yoklamaDB");
  var boxTeskilat = Hive.box<GrupModel>("grupDB");

  List<YoklamaModel> listYoklama = [];
  List<YoklamaModel> denesil = [];

  List<KisiModel> listKisiler = [];
  @override
  void initState() {
    super.initState();
    yoklamaInitState();
  }

  kisilerInitState() {
    for (var element in boxTeskilat.values) {
      if (element.id == widget.teskilatID) {
        listKisiler = element.kisimodel;
      }
    }
  }

  yoklamaInitState() async {
    listYoklama.clear();

    for (var element in boxYoklama.values) {
      denesil.add(element);
      if (element.toplantiID == widget.toplatiID &&
          element.teskilatID == widget.teskilatID) {
        listYoklama.add(element);
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(denesil.length.toString()),
          actions: [
            IconButton(
                onPressed: () async {
                  //     await yoklamaAlma(listKisiler[1], widget.teskilatID);
                  setState(() {});
                },
                icon: const Icon(Icons.do_disturb))
          ],
        ),
        body: listYoklama.isEmpty
            ? const Center(
                child: Text('Yoklama alınacak kimse bulunamadı'),
              )
            : ListView.builder(
                itemCount: listYoklama.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      await yoklamaAlma(listYoklama[index]);
                      setState(() {});
                    },
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(listYoklama[index].kisiModel!.adSoyad),
                        trailing:
                            Text(listYoklama[index].katilimDurumu.toString()),
                        // ignore: unnecessary_null_comparison
                      ),
                    ),
                  );
                },
              ));
  }

  Future<void> yoklamaAlma(YoklamaModel yoklamaModel) async {
    var guncelleme = YoklamaModel(
        id: yoklamaModel.id,
        teskilatID: yoklamaModel.teskilatID,
        toplantiID: yoklamaModel.toplantiID,
        katilimDurumu: 'F',
        kisiModel: yoklamaModel.kisiModel);

    await boxYoklama.put(yoklamaModel.toplantiID, guncelleme);

    listYoklama[listYoklama
        .indexWhere((element) => element.id == guncelleme.id)] = guncelleme;
  }
}
