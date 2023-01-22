import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmanagmentapp/PersonelSayfalar/personelAyarlar.dart';

import 'package:taskmanagmentapp/model/bireyselGorevler.dart';
import 'package:taskmanagmentapp/model/ekipGorevler.dart';
import 'package:taskmanagmentapp/class/image2.dart';
import 'package:taskmanagmentapp/class/zamanGetir.dart';
import 'package:taskmanagmentapp/login.dart';

class PersonelAnaSayfa extends StatefulWidget {
  const PersonelAnaSayfa({super.key});

  @override
  State<PersonelAnaSayfa> createState() => _PersonelAnaSayfaState();
}

class _PersonelAnaSayfaState extends State<PersonelAnaSayfa> {
  Zaman zaman = new Zaman();

  FirebaseStorage storage = FirebaseStorage.instance;
  String bosluk = ''; //gerekli
  String? indirmeBaglantisi;
  String documentName = 'gorevBaslikbireysel';
  String collectionName = 'BireyselGorevler';
  int toplamBireyselGorev = 0;
  int toplamEkipGorev = 0;
  bool bireyGetir = true;
  bool ekipGetir = false;

  List<BireyselGorevler> _bireyselGorevler = [];
  List<EkipGorevler> _ekipGorevler = [];

  @override
  void initState() {
    super.initState();
    tumGorevGetir('BireyselGorevler/', _bireyselGorevler);
    tumGorevGetir('EkipGorevler/', _ekipGorevler);
    gorevSayiGetir();
    setState(() {
      baglantiAl();
    });
  }

  late Query _usersStream = FirebaseFirestore.instance
      .collection('Kullanicilar')
      .where("kullaniciID", isEqualTo: auth.currentUser!.uid);

  baglantiAl() async {
    try {
      Reference ref = storage
          .ref()
          .child("profilResimleri")
          .child(auth.currentUser!.uid)
          .child("profilResmi.png");

      String url = await ref.getDownloadURL() == null
          ? 'Resim yok'
          : await ref.getDownloadURL();
      setState(() {
        if (url != 'Resim yok') {
          indirmeBaglantisi = url;
        }
      });
    } catch (e) {}
  }

  void gorevSayiGetir() async {
    await FirebaseFirestore.instance
        .collection('BireyselGorevler')
        .where('personelMail', isEqualTo: auth.currentUser!.email)
        .snapshots()
        .listen((data) {
      data.docs.forEach((document) {
        setState(() {
          toplamBireyselGorev++;
        });
      });
    });

    await FirebaseFirestore.instance
        .collection('EkipGorevler')
        .where('personelMail', arrayContains: auth.currentUser!.email)
        .snapshots()
        .listen((data) {
      data.docs.forEach((document) {
        setState(() {
          toplamEkipGorev++;
        });
      });
    });
  }

  void tumGorevGetir(String collection, List list) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .orderBy('sonTarih', descending: true)
        .snapshots()
        .listen((data) {
      data.docs.forEach((document) {
        if (document['personelMail'].contains(auth.currentUser!.email)) {
          setState(() {
            if (collection == 'BireyselGorevler/') {
              list.add(BireyselGorevler(
                gorevBaslikbireysel: document.data()['gorevBaslikbireysel'],
                gorevIcerikbireysel: document.data()['gorevIcerikbireysel'],
                sonTarih: document.data()['sonTarih'],
              ));
            } else {
              list.add(EkipGorevler(
                gorevBaslik: document.data()['gorevBaslikEkip'],
                gorevIcerik: document.data()['gorevIcerikEkip'],
                sonTarih: document.data()['sonTarih'],
                personellerMail: document.data()['personelMail'],
              ));
            }
          });
        }
      });
    });
    print(list);
  }

  gorevGetirSinirli(List list) async {
    _bireyselGorevler.clear();
    if (bireyGetir == true) {
      await FirebaseFirestore.instance
          .collection('BireyselGorevler/')
          .snapshots()
          .listen((data) {
        data.docs.forEach((document) {
          if (document['personelMail'] == auth.currentUser!.email) {
            for (var element in list) {
              if (document.data()['sonTarih'] != element) {
              } else {
                print('Görev Başlığı: ' +
                    document.data()['gorevBaslikbireysel'] +
                    ' // Görev İçeriği: ' +
                    document.data()['gorevIcerikbireysel'] +
                    ' // Son Tarih: ' +
                    document.data()['sonTarih']);
                setState(() {
                  _bireyselGorevler.add(BireyselGorevler(
                    gorevBaslikbireysel: document.data()['gorevBaslikbireysel'],
                    gorevIcerikbireysel: document.data()['gorevIcerikbireysel'],
                    sonTarih: document.data()['sonTarih'],
                  ));
                });
              }
            }
          }
        });
      });
    }
    if (ekipGetir == true) {
      _ekipGorevler.clear();
      await FirebaseFirestore.instance
          .collection('EkipGorevler/')
          .snapshots()
          .listen((data) {
        data.docs.forEach((document) {
          if (document['personelMail'].contains(auth.currentUser!.email)) {
            for (var element in list) {
              if (document.data()['sonTarih'] != element) {
              } else {
                print('Görev Başlığı: ' +
                    document.data()['gorevBaslikEkip'] +
                    ' // Görev İçeriği: ' +
                    document.data()['gorevIcerikEkip'] +
                    ' // Son Tarih: ' +
                    document.data()['sonTarih']);
                setState(() {
                  _ekipGorevler.add(EkipGorevler(
                    gorevBaslik: document.data()['gorevBaslikEkip'],
                    gorevIcerik: document.data()['gorevIcerikEkip'],
                    sonTarih: document.data()['sonTarih'],
                    personellerMail: document.data()['personelMail'],
                  ));
                });
              }
            }
          }
        });
      });
    }
  }

  List<bool> isSelected = [false, false, false];
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/anasayfaback.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Row(
               
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ImageGet(),
                  ),
                  StreamBuilder(
                      stream: _usersStream.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Expanded(
                            child: SizedBox(
                              height: 115,
                              child: ListView(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  return ListTile(
                                    title: Text(
                                      data['Ad'],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      data['Gorev'],
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }
                      }),
                  SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Card(
                  elevation: 25,
                  color: Colors.transparent,
                  child: GestureDetector(
                    child: Container(
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 42, 78, 236),
                            size: 100,
                          ),
                          Text(
                            'Benim Görevlerim',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 78, 236),
                                fontSize: 14),
                          ),
                          SizedBox(
                            child: Text(
                              toplamBireyselGorev.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 42, 78, 236),
                                  fontSize: 20),
                            ),
                          )
                        ],
                      )),
                      width: 175,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isSelected=[false,false,false];
                        ekipGetir = false;
                        bireyGetir = true;
                        _bireyselGorevler.clear();
                        _ekipGorevler.clear();
                        zaman.zamanAyar();
                        tumGorevGetir('BireyselGorevler/', _bireyselGorevler);
                        collectionName = 'BireyselGorevler';
                        documentName = 'gorevBaslikbireysel';
                      });
                    },
                  ),
                ),
                Card(
                  elevation: 25,
                  color: Colors.transparent,
                  child: GestureDetector(
                    child: Container(
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.groups,
                            color: Color.fromARGB(255, 42, 78, 236),
                            size: 100,
                          ),
                          Text(
                            'Ekip Görevleri',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 78, 236),
                                fontSize: 14),
                          ),
                          SizedBox(
                            child: Text(
                              toplamEkipGorev.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 42, 78, 236),
                                  fontSize: 20),
                            ),
                          )
                        ],
                      )),
                      width: 175,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isSelected=[false,false,false];
                        bireyGetir = false;
                        ekipGetir = true;
                        _bireyselGorevler.clear();
                        _ekipGorevler.clear();
                        zaman.zamanAyar();
                        //tumGorevGetirEkip();
                        tumGorevGetir('EkipGorevler/', _ekipGorevler);
                        collectionName = 'EkipGorevler';
                        documentName = 'gorevBaslikEkip';
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ToggleButtons(
                    children: <Widget>[Text("7"), Text("15"), Text("30")],
                    isSelected: isSelected,
                    selectedColor: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black,
                    fillColor: Color.fromARGB(255, 42, 78, 236),
                    onPressed: (newIndex) {
                      if (newIndex == 0) {
                        setState(() {
                          _bireyselGorevler.clear();
                          _ekipGorevler.clear();
                          zaman.zamanAyar();
                          gorevGetirSinirli(zaman.list7);
                        });
                      } else if (newIndex == 1) {
                        setState(() {
                          _bireyselGorevler.clear();
                          _ekipGorevler.clear();
                          zaman.zamanAyar();
                          gorevGetirSinirli(zaman.list15);
                        });
                      } else {
                        setState(() {
                          _bireyselGorevler.clear();
                          _ekipGorevler.clear();
                          zaman.zamanAyar();
                          gorevGetirSinirli(zaman.list30);
                        });
                      }
                      setState(() {
                          for (var i = 0; i < isSelected.length; i++) {
                            if (i == newIndex) {
                              isSelected[i] = true;
                            } else {
                              isSelected[i] = false;
                            }
                          }
                        },
                      );
                    },
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                      height: 250,
                      child: Container(
                          child: ListView.builder(
                            reverse: false,
                            shrinkWrap: true,
                        itemCount: _bireyselGorevler.length == 0
                            ? _ekipGorevler.length
                            : _bireyselGorevler.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: GestureDetector(
                            child: ListTile(
                              title: Text(_bireyselGorevler.length == 0
                                  ? _ekipGorevler[index].gorevBaslik
                                  : _bireyselGorevler[index]
                                      .gorevBaslikbireysel),
                              subtitle: Text(_bireyselGorevler.length == 0
                                  ? _ekipGorevler[index]
                                      .sonTarih
                                      .toString()
                                  : _bireyselGorevler[index].sonTarih),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                context: context,
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/gosterGorev.png"),
                                            fit: BoxFit.cover)),
                                    child: Container(
                                        height: 500,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              _bireyselGorevler.length == 0
                                                  ? _ekipGorevler[index]
                                                      .gorevBaslik
                                                  : _bireyselGorevler[index]
                                                      .gorevBaslikbireysel,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 100,
                                            ),
                                            Container(
                                              width: 300,
                                              child: Text(
                                                  _bireyselGorevler.length == 0
                                                      ? _ekipGorevler[index]
                                                          .gorevIcerik
                                                      : _bireyselGorevler[index]
                                                          .gorevIcerikbireysel),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 300,
                                              child: Text(' ${_bireyselGorevler.length == 0
                                                  ? _ekipGorevler[index]
                                                      .personellerMail
                                                      .toString()
                                                  : bosluk}'),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text('Son teslim tarihi: ${_bireyselGorevler.length == 0
                                                ? _ekipGorevler[index]
                                                    .sonTarih
                                                    .toString()
                                                : _bireyselGorevler[index]
                                                    .sonTarih}'),
                                          ],
                                        )),
                                  );
                                },
                              );
                            },
                          ));
                        },
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
