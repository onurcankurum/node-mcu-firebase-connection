// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Meşe Bilişim Açma Kapama Tuşu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isBusy = true;
  late dynamic _temprature;
  late dynamic _humidity;

  final databaseReference = FirebaseDatabase.instance.reference();

  void _trigerServo() {
    databaseReference.child("led").once().then((DataSnapshot data) {
      if (_isBusy == false) {
        databaseReference.child("led").set({'led': true}).onError(
            (error, stackTrace) => print("işlem gerçekleşmedi"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Query sensors = databaseReference.child('sensors');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text(widget.title),
      ),
      body: Center(
        //burada ise nodemcu yu dinliyoruz
        child: Column(
          children: [
            StreamBuilder(
              stream: databaseReference.child('sensors/').onValue,
              builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                _humidity = (snapshot.data!.snapshot.value['humidty']);
                _temprature = (snapshot.data!.snapshot.value['temprature']);

                if (snapshot.hasData) {
                  return Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "sıcaklık : " + _temprature.toString(),
                            style: TextStyle(fontSize: 40),
                          ),
                          Text(
                            "nem : %" + _humidity.toString(),
                            style: TextStyle(fontSize: 40),
                          )
                        ]),
                  );
                } else if (snapshot.hasError) {
                  return Text("hata oluştu internete bağlı mısınız?");
                } else {
                  return Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "sıcaklık : " + _temprature.toString(),
                            style: TextStyle(fontSize: 40),
                          ),
                          Text(
                            "nem : %" + _humidity.toString(),
                            style: TextStyle(fontSize: 40),
                          )
                        ]),
                  );
                }
              },
            ),
            StreamBuilder(
                stream: databaseReference.child('led/led').onValue,
                builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasData) {
                    _isBusy = snapshot.data!.snapshot.value;
                    return Container(
                      margin: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          if (_isBusy == true) {
                            print("basılıyor");
                          } else {
                            _trigerServo();
                          }
                        },
                        child: Container(
                          width: 200,
                          height: 200,
                          child: CircleAvatar(
                              backgroundColor:
                                  _isBusy ? Colors.black : Colors.amber,
                              child: _isBusy
                                  ? CircularProgressIndicator()
                                  : Text(
                                      "tuşla",
                                      style: TextStyle(fontSize: 40),
                                    )),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("hata oluştu internete bağlı mısınız?");
                  } else {
                    return Text("veri tabanı yok");
                  }
                }),
          ],
        ),
      ),
    );
  }
}
