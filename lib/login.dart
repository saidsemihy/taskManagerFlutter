import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taskmanagmentapp/kayit.dart';
import 'Widgets/bottomNavigationBar.dart';
import 'mvvm/views/admin_anasayfa.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordVisible = true.obs;

  void storeStatusOpen(bool isOpen) {
    _passwordVisible(isOpen);
  }

  TextEditingController kullaniciAdi = TextEditingController();
  TextEditingController kullaniciSifre = TextEditingController();

  Future<void> login() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: kullaniciAdi.text, password: kullaniciSifre.text)
        .then((value) async {
      var gelenDurum = await adminGiris(kullaniciAdi.text);
      print(gelenDurum);
      if (gelenDurum == false) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Example()),
            ((route) => false));
      } else {
      
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AdminAnasayfaView()),
            ((route) => false));
      }
    }).catchError((dynamic error) {
      if (error.toString().contains('invalid-email')) {
        errorMessage('Geçersiz Eposta');
      }
      if (error.toString().contains('user-not-found')) {
        errorMessage('Kullanıcı Bulunamadı');
      }
      if (error.toString().contains('wrong-password')) {
        errorMessage('Yanlış Şifre');
      }
    });
  }

  errorMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/backlogin1.png"), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                SizedBox(
                  height: 400,
                ),
                Container(
                  width: 385,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: kullaniciAdi,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.check),
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.blue,
                            ),
                            label: Text('Email')),
                      ),
                      Obx(
                        () => TextField(
                          obscureText: _passwordVisible.value,
                          controller: kullaniciSifre,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.key,
                              color: Colors.blue,
                            ),
                            label: Text('Şifre'),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible.value
                                    ? Icons.lock
                                    : Icons.lock_open,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                storeStatusOpen(!_passwordVisible.value);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
             
                SizedBox(
                  height: 25,
                ),
                Container(
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: Text('Giriş Yap'))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 135,
                        child: Divider(
                          color: Colors.grey,
                        )),
                    Text(
                      'Veya',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    SizedBox(
                      width: 135,
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                          ((route) => false));
                    },
                    child: Text(
                      'Kayıt Ol',
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
        ),
      ),
    );
  }

  Future<bool> adminGiris(var y) async {
    var gelenDurum;
    await FirebaseFirestore.instance
        .collection("Kullanicilar")
        .doc(y)
        .get()
        .then((gelenVeri) {
      setState(() {
        gelenDurum = gelenVeri.data()!['admin'];
      });
    });

    print(gelenDurum);
    return Future.value(gelenDurum);
  }
}
