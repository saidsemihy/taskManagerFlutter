import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';





class DuyuruGoruntule extends StatefulWidget {
  const DuyuruGoruntule({super.key});

  @override
  State<DuyuruGoruntule> createState() => _DuyuruGoruntuleState();
}

class _DuyuruGoruntuleState extends State<DuyuruGoruntule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/duyuruEkleBack.png"),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Duyurular').orderBy("id", descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          final documents = snapshot.data!.docs;

                          return SizedBox(
                            height: 500,
                            child: ListView.builder(
                              reverse: false,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) => Container(
                                child: Card(
                                  child: ListTile(
                                    title:
                                        Text(documents[index]['duyuruBaslik']),
                                    subtitle:
                                        Text(documents[index]['duyuruIcerik']),
                                  ),
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
        ));
  }
}
