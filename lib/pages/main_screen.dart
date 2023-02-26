import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sample_todo/firebase_options.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  _MainScreenState(){
    initFireBase();
  }
  void initFireBase() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
            title: Text('List ToDo'),
            centerTitle: true,
        ),
      body: Column(
          children: [
            Text('Main Screen', style: TextStyle(color: Colors.white),),
            ElevatedButton(onPressed: () {
              //Navigator.pushNamed(context, '/todo'); // слой и стрелка возврата

              //Navigator.pushNamedAndRemoveUntil(context,"/todo", (route) => false);
              Navigator.pushReplacementNamed(context, "/todo"); //слоя нет
            }, child: Text('Next'))
        ],
      ),
    );
  }
}
