import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskmanagmentapp/class/image2.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController eMail = TextEditingController();
  TextEditingController sifre = TextEditingController();
  TextEditingController sifre1 = TextEditingController();
  TextEditingController kullaniciAdi = TextEditingController();
  TextEditingController kullaniciSoyadi = TextEditingController();
  TextEditingController kullaniciGorev = TextEditingController();
  TextEditingController kullaniciTel = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/kayitolback.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: [
        SizedBox(height: 175,),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                      TextField(
                        controller: kullaniciAdi,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            suffixIcon: Icon(Icons.check),
                            prefixIcon: Icon(
                              Icons.title,
                              color: Colors.blue,
                            ),
                            label: Text('Ad')),
                      ),
                           TextField(
                        controller: kullaniciSoyadi,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            suffixIcon: Icon(Icons.check),
                            prefixIcon: Icon(
                              Icons.title,
                              color: Colors.blue,
                            ),
                            label: Text('Soyad')),
                      ),
                           TextField(
                        controller: kullaniciGorev,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            suffixIcon: Icon(Icons.check),
                            prefixIcon: Icon(
                              Icons.task,
                              color: Colors.blue,
                            ),
                            label: Text('Görev')),
                      ),
                    TextField(
                        controller: kullaniciTel,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            suffixIcon: Icon(Icons.check),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.blue,
                            ),
                            label: Text('Telefon')),
                      ),
                   
               TextField(
                        controller: eMail,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            suffixIcon: Icon(Icons.check),
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.blue,
                            ),
                            label: Text('Email')),
                      ),
                       TextField(
                        controller: sifre,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            suffixIcon: Icon(Icons.check),
                            prefixIcon: Icon(
                              Icons.key,
                              color: Colors.blue,
                            ),
                            label: Text('Sifre')),
                      ),
                           TextField(
                        controller: sifre1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            suffixIcon: Icon(Icons.check),
                            prefixIcon: Icon(
                              Icons.key,
                              color: Colors.blue,
                            ),
                            label: Text('Sifre Tekrar')),
                      ),
               
                    Container(
                        width: 300,
                        child: ElevatedButton(
                            onPressed: () {
                              if (
                                  eMail.text != '' &&
                                  sifre.text != '') {
                                register();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    ((route) => false));
                                errorMessage('Kayit Başarılı!');
                              } else {
                                errorMessage('Lütfen Doğru Değerleri Girin!');
                              }
                            },
                            child: Text('Kayıt Ol'))),
                    Container(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              ((route) => false));
                        },
                        child: Text(
                          'Zaten hesabın var mı?',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            side: BorderSide(color: Colors.grey)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> register() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: eMail.text, password: sifre.text)
          .then((value) {
        FirebaseFirestore.instance
            .collection('Kullanicilar')
            .doc(eMail.text)
            .set({
          'kullaniciID': auth.currentUser!.uid,
          'email': eMail.text,
          'sifre': sifre.text,
          'admin': false,
          'Ad': kullaniciAdi.text,
          'Soyad': kullaniciSoyadi.text,
          'Gorev': kullaniciGorev.text,
          'Tel': kullaniciTel.text,
        
        });
      });
    } catch (e) {
      errorMessage('Bir şeyler ters gitti, tekrar kontrol edin');
    }
  }

  errorMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
