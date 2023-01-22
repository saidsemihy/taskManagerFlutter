import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taskmanagmentapp/mvvm/views/admin_anasayfa.dart';
import 'package:taskmanagmentapp/mvvm/views/duyuru_goruntule_model.dart';

import '../models/duyuru.dart';

class DuyuruGoruntuleView extends StatefulWidget {
  const DuyuruGoruntuleView({super.key});

  @override
  State<DuyuruGoruntuleView> createState() => _DuyuruGoruntuleViewState();
}

class _DuyuruGoruntuleViewState extends State<DuyuruGoruntuleView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DuyuruGoruntuleViewModel>(
      create: (_) => DuyuruGoruntuleViewModel(),
      builder: (context, child) => Scaffold(
        backgroundColor: Color.fromARGB(255, 33, 82, 243),
        body: Center(
          child: Column(children: [
            StreamBuilder<List<Duyurular>>(
              stream:
                  Provider.of<DuyuruGoruntuleViewModel>(context, listen: false)
                      .getDuyurular(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  print(asyncSnapshot.error);
                  return Center(
                      child:
                          Text('Bir Hata Oluştu, daha sonra tekrar deneyiniz'));
                } else {
                  if (!asyncSnapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    List<Duyurular> duyuruList = asyncSnapshot.data!;
                    return BuildListView(gorevList: duyuruList); //, key: null,
                  }
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 300),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back,color: Colors.blue,),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class BuildListView extends StatefulWidget {
  const BuildListView({
    super.key,
    required this.gorevList,
  });

  final List<Duyurular> gorevList;

  @override
  _BuildListViewState createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  Message(String message,Color c) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: c));
  }

  TextEditingController duyuruBaslik = TextEditingController();
  TextEditingController duyuruIcerik = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var fullList = widget.gorevList;
    return Flexible(
      child: ListView.builder(
        itemCount: fullList.length,
        itemBuilder: (context, index) => GestureDetector(
          child: SizedBox(
            height: 100,
            child: Card(
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(fullList[index].duyuruBaslik),
                      subtitle: Text(fullList[index].duyuruIcerik),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            duyuruBaslik.text = fullList[index].duyuruBaslik;
            duyuruIcerik.text = fullList[index].duyuruIcerik;
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Görev Detayları"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: duyuruBaslik,
                          decoration: InputDecoration(
                            labelText: "Görev Başlığı",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: duyuruIcerik,
                          decoration: InputDecoration(
                            labelText: "Görev İçeriği",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Kapat")),
                      TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();

                            FirebaseFirestore.instance
                                .collection("Duyurular")
                                .doc(fullList[index].id)
                                .delete().then((value) => Message(
                                    "Duyuru Başarıyla Silindi!", Colors.red));
                          },
                          child: Text('Sil')),
                      //save butonu
                      TextButton(
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection("Duyurular")
                              .doc(fullList[index].id)
                              .update({
                            'duyuruBaslik': duyuruBaslik.text,
                            'duyuruIcerik': duyuruIcerik.text,
                          }).then((value) => Message(
                              "Duyuru Başarıyla Güncellendi!", Colors.green));

                          duyuruBaslik.clear();
                          duyuruIcerik.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text('Güncelle'),
                      )
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
