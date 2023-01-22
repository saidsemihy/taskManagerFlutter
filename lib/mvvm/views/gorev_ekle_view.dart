import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'admin_anasayfa.dart';
import 'gorev_ekle_model.dart';

class GorevEkleView extends StatefulWidget {
  const GorevEkleView({super.key});

  @override
  State<GorevEkleView> createState() => _GorevEkleViewState();
}

class _GorevEkleViewState extends State<GorevEkleView> {
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

  String secilenMail = "";
  TextEditingController gorevBaslik = TextEditingController();
  TextEditingController gorevIcerik = TextEditingController();
  TextEditingController gorevTarih = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    gorevBaslik.dispose();
    gorevIcerik.dispose();
    gorevTarih.dispose();
    secilenMail = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GorevEkleViewModel>(
      create: (_) => GorevEkleViewModel(),
      builder: (context, _) => Scaffold(
          body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/gorevEkleBack.png"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        child: Text(
                          'Personel:$secilenMail',
                          textAlign: TextAlign.start,
                        )),
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
                            hintText: 'Görev İçerik', icon: Icon(Icons.task)),
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
                          hintText: "Son Tarih",
                          icon: Icon(Icons.date_range),
                        ),
                      ),
                      onDoubleTap: () {
                        setState(() {
                          _selectDate(context);
                          gorevTarih.text = selectFormat;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 150,
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
                                                'Görevi Vereceğiniz Personeli Seçiniz',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 135),
                                                  child: StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'Kullanicilar')
                                                          .snapshots(),
                                                      builder: (context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        } else {
                                                          final documents =
                                                              snapshot
                                                                  .data!.docs;
                                                          return SizedBox(
                                                            height: 200,
                                                            child: ListView
                                                                .builder(
                                                              itemCount:
                                                                  snapshot
                                                                      .data!
                                                                      .docs
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                          index) =>
                                                                      Container(
                                                                child:
                                                                    GestureDetector(
                                                                  child: Text(
                                                                    documents[
                                                                            index]
                                                                        [
                                                                        'email'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      secilenMail =
                                                                          documents[index]
                                                                              [
                                                                              'email'];
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            child: Text("Personel Seç"),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await context
                                      .read<GorevEkleViewModel>()
                                      .addYeniGorev(
                                          gorevBaslikbireysel: gorevBaslik.text,
                                          gorevIcerikbireysel: gorevIcerik.text,
                                          personelMail: secilenMail,
                                          sonTarih: selectFormat)
                                      .then((value) =>
                                          Message('Görev Başarıyla Eklendi'))
                                      .then((value) {
                                    setState(() {
                                      gorevBaslik.clear();
                                      gorevIcerik.clear();
                                      gorevTarih.clear();
                                      secilenMail = '';
                                    });
                                  });
                                }
                                //Navigator.pop(context);
                              },
                              child: Text('Kaydet')),
                        ),
                      ],
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
            ),
          ],
        ),
      )),
    );
  }
}
