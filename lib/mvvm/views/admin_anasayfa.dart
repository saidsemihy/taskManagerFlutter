import 'package:flutter/material.dart';
import 'package:taskmanagmentapp/login.dart';
import 'package:taskmanagmentapp/mvvm/views/duyuru_ekle_view.dart';
import 'package:taskmanagmentapp/mvvm/views/duyuru_goruntule_view.dart';


import 'ekipgorevekle_view.dart';
import 'ekipgorevgoruntule_view.dart';
import 'gorev_ekle_view.dart';
import 'gorev_goruntule_view.dart';

class AdminAnasayfaView extends StatefulWidget {
  const AdminAnasayfaView({super.key});

  @override
  State<AdminAnasayfaView> createState() => _AdminAnasayfaViewState();
}

class _AdminAnasayfaViewState extends State<AdminAnasayfaView> {

  
  @override
  Widget build(BuildContext context) {




    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 82, 243),
        body: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            Text('PANEL',style: TextStyle(fontSize: 40,color: Colors.white),),
            SizedBox(height: 10,),
            Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            Icons.task,
                            color: Color.fromARGB(255, 42, 78, 236),
                            size: 100,
                          ),
                          Text(
                            'Gorev Ekle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 78, 236),
                                fontSize: 14),
                          ),
                     
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
                         Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => GorevEkleView()),
                      ((route) => false));
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
                            Icons.library_books_rounded,
                            color: Color.fromARGB(255, 42, 78, 236),
                            size: 100,
                          ),
                          Text(
                            'Görevleri Görüntüle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 78, 236),
                                fontSize: 14),
                          ),
                     
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
                        Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => GorevGoruntule()),
                      ((route) => false));
                    },
                  ),
                ),
            ],),

            Row(
              
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            Icons.group_add,
                            color: Color.fromARGB(255, 42, 78, 236),
                            size: 100,
                          ),
                          Text(
                            'Ekip Görevi Ekle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 78, 236),
                                fontSize: 14),
                          ),
                     
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
                      Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ekipGorevEkleView()),
                      ((route) => false));
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
                            Icons.manage_search_sharp,
                            color: Color.fromARGB(255, 42, 78, 236),
                            size: 100,
                          ),
                          Text(
                            'Ekip Görevlerini Görüntüle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 78, 236),
                                fontSize: 14),
                          ),
                     
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => EkipGorevGoruntule()),
                      ((route) => false));
                    },
                  ),
                ),
            ],),
            Row(
                                      mainAxisAlignment: MainAxisAlignment.center,

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
                            Icons.notification_add,
                            color: Color.fromARGB(255, 42, 78, 236),
                            size: 100,
                          ),
                          Text(
                            'Duyuru Ekle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 78, 236),
                                fontSize: 14),
                          ),
                     
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => DuyuruEkleView()),
                      ((route) => false));
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
                            Icons.exit_to_app,
                            color: Color.fromARGB(255, 42, 78, 236),
                            size: 100,
                          ),
                          Text(
                            'Çıkış Yap',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 42, 78, 236),
                                fontSize: 14),
                          ),
                     
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      ((route) => false));
                    },
                  ),
                ),
            ],)
       
          ],
        ));
  }
}
