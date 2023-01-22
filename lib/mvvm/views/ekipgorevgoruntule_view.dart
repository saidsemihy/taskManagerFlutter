import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/ekipGorev.dart';
import 'admin_anasayfa.dart';

import 'ekipgorevgoruntule_model.dart';

class EkipGorevGoruntule extends StatefulWidget {
  const EkipGorevGoruntule({super.key});

  @override
  State<EkipGorevGoruntule> createState() => _EkipGorevGoruntuleState();
}

class _EkipGorevGoruntuleState extends State<EkipGorevGoruntule> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EkipGorevGoruntuleViewModel>(
      create: (_) => EkipGorevGoruntuleViewModel(),
      builder: (context, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/ekipGorevGoruntuleBack.png"),
                  fit: BoxFit.cover)),
          child: Center(
            child: Column(children: [
              StreamBuilder<List<EkipGorev>>(
                stream: Provider.of<EkipGorevGoruntuleViewModel>(context,
                        listen: false)
                    .getEkipGorevler(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    print(asyncSnapshot.error);
                    return Center(
                        child: Text(
                            'Bir Hata Oluştu, daha sonra tekrar deneyiniz'));
                  } else {
                    if (!asyncSnapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      List<EkipGorev> gorevList = asyncSnapshot.data!;
                      return BuildListView(
                          gorevList: gorevList,
                          documents: gorevList); //, key: null,
                    }
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 300),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminAnasayfaView()),
                        ((route) => false));
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.blue,
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class BuildListView extends StatefulWidget {
  const BuildListView({
    super.key,
    required this.gorevList,
    required this.documents,
  });

  final List<EkipGorev> gorevList;
  final documents;

  @override
  _BuildListViewState createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  DateTime selectedDate = DateTime.now();
  //var selectFormat=DateTime(2021, 10, 10);
  var selectFormat = 'asd';
  var formatter = DateFormat('dd/MM/yyyy');
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectFormat = DateFormat('dd/MM/yyyy').format(selectedDate);
        sonTarihController.text = selectFormat;
      });
    }
  }

  TextEditingController gorevBaslikController = TextEditingController();
  TextEditingController gorevIcerikController = TextEditingController();
  TextEditingController sonTarihController = TextEditingController();
  bool isFiltering = false;
  late List<EkipGorev> filteredList;
  Message(String message,Color c) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: c));
  }

  @override
  Widget build(BuildContext context) {
    var fullList = widget.gorevList;
    var documents = widget.documents;

    return Flexible(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 75,
        ),
        Container(
          height: 500,
          width: 375,
          child: ListView.builder(
            itemCount: isFiltering ? filteredList.length : fullList.length,
            itemBuilder: (context, index) => GestureDetector(
              child: SizedBox(
                height: 100,
                child: Card(
                  elevation: 5,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(fullList[index].gorevBaslikEkip),
                          trailing: Text(fullList[index].sonTarih),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                gorevBaslikController.text = fullList[index].gorevBaslikEkip;
                gorevIcerikController.text = fullList[index].gorevIcerikEkip;
                sonTarihController.text = fullList[index].sonTarih;

                showDialog(
                    barrierColor: Color.fromARGB(255, 33, 82, 243),
                    context: context,
                    builder: (context) {
                      return Center(
                        child: SingleChildScrollView(
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            title: Text(
                              "Görev Detayları",
                              textAlign: TextAlign.center,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: gorevBaslikController,
                                  decoration: InputDecoration(
                                    labelText: "Görev Başlığı",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  keyboardType: TextInputType.multiline,
                                  controller: gorevIcerikController,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    labelText: "Görev İçeriği",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  child: TextField(
                                    controller: sonTarihController,
                                    decoration: InputDecoration(
                                      labelText: "Son Tarih",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  onDoubleTap: () {
                                    _selectDate(context);
                                    sonTarihController.text = selectFormat;
                                  },
                                ),
                                Text(fullList[index].personelMail.toString())
                              ],
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Kapat")),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();

                                        FirebaseFirestore.instance
                                            .collection("EkipGorevler")
                                            .doc(fullList[index].id)
                                            .delete().then((value) => Message(
                                                "Görev Başarıyla Silindi",Colors.red));
                                      },
                                      child: Text('Sil')),
                                  //save butonu
                                  TextButton(
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection("EkipGorevler")
                                          .doc(fullList[index].id)
                                          .update({
                                        'gorevBaslikEkip':
                                            gorevBaslikController.text,
                                        'gorevIcerikEkip':
                                            gorevIcerikController.text,
                                        'sonTarih': sonTarihController.text,
                                      }).then((value) => Message(
                                          "Görev Başarıyla Güncellendi",Colors.green));

                                      gorevBaslikController.clear();
                                      gorevIcerikController.clear();
                                      sonTarihController.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Güncelle'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ),
      ],
    ));
  }
}
