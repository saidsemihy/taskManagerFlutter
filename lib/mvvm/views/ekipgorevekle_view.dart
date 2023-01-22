import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'admin_anasayfa.dart';
import 'ekipgorevekle_model.dart';

class ekipGorevEkleView extends StatefulWidget {
  const ekipGorevEkleView({super.key});

  @override
  State<ekipGorevEkleView> createState() => _ekipGorevEkleViewState();
}

class _ekipGorevEkleViewState extends State<ekipGorevEkleView> {
  DateTime selectedDate = DateTime.now();
  //var selectFormat=DateTime(2021, 10, 10);
  var selectFormat = '';
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
        gorevTarih.text = selectFormat;
      });
    }
  }

  List<dynamic> secilenMail = [];

  //String secilenMail = "";
  TextEditingController gorevBaslik = TextEditingController();
  TextEditingController gorevIcerik = TextEditingController();
  TextEditingController gorevTarih = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  void dispose() {
    // TODO: implement dispose
    gorevBaslik.dispose();
    gorevIcerik.dispose();
    gorevTarih.dispose();
    secilenMail.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EkipGorevEkleModel>(
      create: (_) => EkipGorevEkleModel(),
      builder: (context, _) => Scaffold(
          body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/ekipGorevEkleBack.png"),
                fit: BoxFit.cover)),
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$secilenMail'),
              TextFormField(
                  controller: gorevBaslik,
                  decoration: InputDecoration(
                      hintText: 'Görev Başlığı', icon: Icon(Icons.title)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Görev Başlığı Giriniz';
                    } else {
                      return null;
                    }
                  }),
              TextFormField(
                  controller: gorevIcerik,
                  decoration: InputDecoration(
                      hintText: 'Görev gorevIcerik', icon: Icon(Icons.task)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Görev içeriği Giriniz';
                    } else {
                      return null;
                    }
                  }),
              GestureDetector(
                child: TextField(
                  controller: gorevTarih,
                  decoration: InputDecoration(
                    icon: Icon(Icons.date_range),
                    labelText: "Son Tarih",
                  ),
                ),
                onDoubleTap: () {
                  setState(() {
                    _selectDate(context);
                    gorevTarih.text = selectFormat;
                  });
                },
              ),
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        context: context,
                        builder: (context) => Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/personelGosterBack.png"),
                                      fit: BoxFit.cover)),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Görevi Vereceğiniz Ekibi Seçiniz',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 135),
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('Kullanicilar')
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              final documents =
                                                  snapshot.data!.docs;
                                              return SizedBox(
                                                height: 100,
                                                child: ListView.builder(
                                                  itemCount: snapshot
                                                      .data!.docs.length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          Container(
                                                    child: GestureDetector(
                                                      child: Text(
                                                        documents[index]
                                                            ['email'],
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          if (secilenMail
                                                              .contains(documents[
                                                                      index]
                                                                  ['email'])) {
                                                          } else {
                                                            secilenMail.add(
                                                                documents[index]
                                                                    ['email']);
                                                            print(secilenMail
                                                                .toString());
                                                            print(secilenMail);
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  },
                  child: Text('Personelleri Seç'),
                ),
              ),
              Container(
                width: 300,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await context
                            .read<EkipGorevEkleModel>()
                            .addYeniGorev(
                                gorevBaslikEkip: gorevBaslik.text,
                                gorevIcerikEkip: gorevIcerik.text,
                                personelMail: secilenMail,
                                sonTarih: selectFormat)
                            .then(
                                (value) => Message("Görev Başarıyla Eklendi"));
                      }
                      //Navigator.pop(context);
                      setState(() {
                        gorevBaslik.clear();
                        gorevIcerik.clear();
                        secilenMail.clear();
                        gorevTarih.clear();
                        selectFormat = "";
                      });
                    },
                    child: Text('Kaydet')),
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
                  child: Icon(Icons.arrow_back),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
