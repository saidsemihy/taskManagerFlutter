import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taskmanagmentapp/mvvm/views/duyuru_ekle_model.dart';
import 'package:taskmanagmentapp/mvvm/views/duyuru_goruntule_view.dart';

import 'admin_anasayfa.dart';

class DuyuruEkleView extends StatefulWidget {
  const DuyuruEkleView({super.key});

  @override
  State<DuyuruEkleView> createState() => _DuyuruEkleViewState();
}

class _DuyuruEkleViewState extends State<DuyuruEkleView> {
  TextEditingController duyuruBaslik = TextEditingController();
  TextEditingController duyuruIcerik = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void dispose() {
    // TODO: implement dispose
    duyuruBaslik.dispose();
    duyuruIcerik.dispose();
    super.dispose();
  }

  Message(String message,Color c) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: c));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DuyuruEkleModel>(
      create: (_) => DuyuruEkleModel(),
      builder: (context, _) => Scaffold(
          body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/duyuruEkleBack.png"),
                fit: BoxFit.cover)),
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  controller: duyuruBaslik,
                  decoration: InputDecoration(
                      hintText: 'Duyuru Başlığı',
                      icon: Icon(Icons.notification_add)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Duyuru Başlığı Giriniz';
                    } else {
                      return null;
                    }
                  }),
              TextFormField(
                  controller: duyuruIcerik,
                  decoration: InputDecoration(
                      hintText: 'Duyuru İçeriği',
                      icon: Icon(Icons.text_fields)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Duyuru İçeriği Giriniz';
                    } else {
                      return null;
                    }
                  }),
              Container(
                width: 300,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await context
                            .read<DuyuruEkleModel>()
                            .addYeniDuyuru(
                              duyuruBaslik: duyuruBaslik.text,
                              duyuruIcerik: duyuruIcerik.text,
                            )
                            .then((value) => Message("Duyuru Eklendi",Colors.green));
                      }
                    },
                    child: Text("Duyuru Ekle")),
              ),
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DuyuruGoruntuleView()),
                    );
                  },
                  child: Text("Duyuruları Görüntüle"),
                ),
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
              ),
            ],
          ),
        ),
      )),
    );
  }
}
