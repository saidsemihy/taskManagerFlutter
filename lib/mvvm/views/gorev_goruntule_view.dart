import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/bireyselGorev.dart';
import 'admin_anasayfa.dart';
import 'gorev_goruntule_model.dart';

class GorevGoruntule extends StatefulWidget {
  const GorevGoruntule({super.key});

  @override
  State<GorevGoruntule> createState() => _GorevGoruntuleState();
}

class _GorevGoruntuleState extends State<GorevGoruntule> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GorevGoruntuleViewModel>(
      create: (_) => GorevGoruntuleViewModel(),
      builder: (context, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/gorevleriGoruntuleBack.png"),
                  fit: BoxFit.cover)),
          child: Center(
            child: Column(children: [
              StreamBuilder<List<bireyselGorev>>(
                stream:
                    Provider.of<GorevGoruntuleViewModel>(context, listen: false)
                        .getBireyselGorevler(),
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
                      List<bireyselGorev> gorevList = asyncSnapshot.data!;
                      return BuildListView(gorevList: gorevList); //, key: null,
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
  });

  final List<bireyselGorev> gorevList;

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

  Message(String message,Color c) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: c));
  }

  TextEditingController gorevBaslikController = TextEditingController();
  TextEditingController gorevIcerikController = TextEditingController();
  TextEditingController sonTarihController = TextEditingController();
  bool isFiltering = false;
  late List<bireyselGorev> filteredList;

  @override
  Widget build(BuildContext context) {
    var fullList = widget.gorevList;
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
                          title: Text(fullList[index].gorevBaslikbireysel),
                          trailing: Text(fullList[index].sonTarih),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                gorevBaslikController.text =
                    fullList[index].gorevBaslikbireysel;
                gorevIcerikController.text =
                    fullList[index].gorevIcerikbireysel;
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
                                  maxLines: 5,
                                  controller: gorevIcerikController,
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
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    'Personel:  ${fullList[index].personelMail.toString()}')
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
                                            .collection("BireyselGorevler")
                                            .doc(fullList[index].id)
                                            .delete().then((value) => Message(
                                                "Görev başarıyla silindi!",Colors.red));
                                      },
                                      child: Text('Sil')),
                                  //save butonu
                                  TextButton(
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection("BireyselGorevler")
                                          .doc(fullList[index].id)
                                          .update({
                                        'gorevBaslikbireysel':
                                            gorevBaslikController.text,
                                        'gorevIcerikbireysel':
                                            gorevIcerikController.text,
                                        'sonTarih': sonTarihController.text,
                                      }).then((value) => Message(
                                              "Görev başarıyla güncellendi!",Colors.green));

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
