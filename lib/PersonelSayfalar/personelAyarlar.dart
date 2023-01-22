import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanagmentapp/PersonelSayfalar/personelAnaSayfa.dart';

import '../Widgets/bottomNavigationBar.dart';
import '../class/image2.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class PersonelAyar extends StatefulWidget {
  const PersonelAyar({super.key});

  @override
  State<PersonelAyar> createState() => _PersonelAyarState();
}

class _PersonelAyarState extends State<PersonelAyar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/profilback.png"), fit: BoxFit.cover)),
        child: personelAyar(),
      ),
    );
  }
}

class personelAyar extends StatefulWidget {
  @override
  State<personelAyar> createState() => _personelAyarState();
}

class _personelAyarState extends State<personelAyar> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //images.baglantiAl();
    setState(() {});
  }

  bool priceupdate_value = false;
  final _passwordVisible = true.obs;

  void storeStatusOpen(bool isOpen) {
    _passwordVisible(isOpen);
  }

  TextEditingController eMail = TextEditingController();

  TextEditingController sifre = TextEditingController();

  TextEditingController eMail1 = TextEditingController();

  TextEditingController sifre1 = TextEditingController();

  TextEditingController kullaniciAdi = TextEditingController();

  TextEditingController kullaniciSoyadi = TextEditingController();

  TextEditingController kullaniciGorev = TextEditingController();

  TextEditingController kullaniciTel = TextEditingController();

  personelGuncelle() async {
    await FirebaseFirestore.instance
        .collection("Kullanicilar")
        .doc('${auth.currentUser!.email}')
        .update({
      'email': eMail.text == null ? '' : eMail.text,
      'sifre': sifre.text == null ? '' : sifre.text,
      'Ad': kullaniciAdi.text == null ? '' : kullaniciAdi.text,
      'Soyad': kullaniciSoyadi.text == null ? '' : kullaniciSoyadi.text,
      'Gorev': kullaniciGorev.text == null ? '' : kullaniciGorev.text,
      'Tel': kullaniciTel.text == null ? '' : kullaniciTel.text,
    }).whenComplete(() => print("Kullanici Güncellendi"));
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    Query _usersStream = FirebaseFirestore.instance
        .collection('Kullanicilar')
        .where("kullaniciID", isEqualTo: auth.currentUser!.uid);

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            kullaniciAdi.text = data['Ad'];
            kullaniciSoyadi.text = data['Soyad'];
            kullaniciGorev.text = data['Gorev'];
            kullaniciTel.text = data['Tel'];

            eMail.text = data['email'];
            sifre.text = data['sifre'];

            return Column(
              children: [
                ImageGet(),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 300,
                  child: Column(children: [
                    TextField(
                      controller: kullaniciAdi,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          suffixIcon: Icon(Icons.check),
                          prefixIcon: Icon(
                            Icons.key,
                            color: Colors.blue,
                          ),
                          label: Text('Kullanici Adi')),
                      onTap: () {
                        kullaniciAdi.clear();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: kullaniciSoyadi,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          suffixIcon: Icon(Icons.check),
                          prefixIcon: Icon(
                            Icons.key,
                            color: Colors.blue,
                          ),
                          label: Text('Soyad')),
                      onTap: () {
                        kullaniciSoyadi.clear();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: kullaniciGorev,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          suffixIcon: Icon(Icons.check),
                          prefixIcon: Icon(
                            Icons.key,
                            color: Colors.blue,
                          ),
                          label: Text('Görev')),
                      onTap: () {
                        kullaniciGorev.clear();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: kullaniciTel,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          suffixIcon: Icon(Icons.check),
                          prefixIcon: Icon(
                            Icons.key,
                            color: Colors.blue,
                          ),
                          label: Text('Telefon')),
                      onTap: () {
                        kullaniciTel.clear();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      readOnly: true,
                      controller: eMail,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          suffixIcon: Icon(Icons.check),
                          prefixIcon: Icon(
                            Icons.key,
                            color: Colors.blue,
                          ),
                          label: Text('Email')),
                    ),
                  ]),
                ),
                Container(
                  height: 50,
                  child: CheckboxListTile(
                    title: Text(
                      "Şifrenizi değiştirmek istiyormusunuz?",
                      style: TextStyle(color: Colors.blue),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: priceupdate_value,
                    onChanged: (priceupdateValue) {
                      setState(() {
                        priceupdate_value = priceupdateValue!;
                      });
                    },
                  ),
                ),
                if (priceupdate_value)
                  Obx(
                    () => Container(
                      width: 300,
                      child: TextFormField(
                        controller: sifre,
                        obscureText: _passwordVisible.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text('sifre'),
                          hintText: "Şifre",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              storeStatusOpen(!_passwordVisible.value);
                            },
                          ),
                        ),
                        onTap: () {
                          sifre.clear();
                        },
                      ),
                    ),
                  ),
                Container(
                  width: 300,
                  child: ElevatedButton(
                      onPressed: (() {
                        personelGuncelle();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PersonelAnaSayfa()),
                        );
                      }),
                      child: Text("Güncelle")),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
