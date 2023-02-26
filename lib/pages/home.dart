import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sample_todo/firebase_options.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todoList = [];
  String _userToDo="";

 /* void initFireBase() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initFireBase();
    todoList.addAll(['Buy milk',"Wash dishes","Купить картошку"]);
  }

  ListView getListView(AsyncSnapshot<QuerySnapshot> snapShot){
    return  ListView.builder(
        itemCount: snapShot.data!.docs.length ,
        itemBuilder: (BuildContext context, int index ){
          return Dismissible(
            key: Key(snapShot.data!.docs[index].id),
            child: Card(
              child: ListTile(title: Text(snapShot.data!.docs[index].get('item')),
                trailing: IconButton(
                  icon: Icon(Icons.delete_sweep,
                    color: Colors.orangeAccent,),
                  onPressed: () {
                    setState(() { todoList.removeAt(index);});
                  },
                ),
              ),
            ),
            onDismissed: (direction){
              //if (direction == DismissDirection)
              setState(() {
                todoList.removeAt(index);
              });
            },
          );
        }
    );
  }
  void _menuOpen(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context){
        return Scaffold(
        appBar: AppBar(title: Text("Menu"),),
        body: Row(
          children: [
            TextButton(onPressed:(){
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: Text("To Main")
            ),
            Padding(padding: EdgeInsets.only(left: 15)),
            Text("Simple menu"),
          ],

        ),
        );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('List ToDo'),
        centerTitle: true,
        actions: [
          IconButton(onPressed:  _menuOpen,
              icon: Icon(Icons.menu_outlined))
        ],
      ),
      /*// без БД
      body: ListView.builder(
          itemCount: todoList.length ,
          itemBuilder: (BuildContext context, int index ){
              return Dismissible(
                  key: Key(todoList[index]),
                  child: Card(
                    child: ListTile(title: Text(todoList[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_sweep,
                      color: Colors.orangeAccent,),
                      onPressed: () {
                        setState(() { todoList.removeAt(index);});
                        },
                    ),
                    ),
                  ),
                onDismissed: (direction){
                    //if (direction == DismissDirection)
                  setState(() {
                    todoList.removeAt(index);
                  });
                },
              );
          }
      ),*/
      //c БД
      body: StreamBuilder( // asunc regim
        stream: FirebaseFirestore.instance.collection("items").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot){
          if( !snapShot.hasData) return Text("No data");
          return getListView(snapShot);
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          showDialog(context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add element'),
                content: TextField(
                  onChanged: (String value) {
                      _userToDo = value;
                    },
                  ),
                actions: [
                  OutlinedButton(onPressed: () {
                    // с БД
                    FirebaseFirestore.instance.collection('items')
                        .add({'item': _userToDo});
                    /*
                    //не используя бд. Только состояния
                    setState(() {
                      todoList.add(_userToDo);
                    });
*/
                    Navigator.pop(context); //закрыть все всплывающие окна на текущей странице
                  }, child: Text("Save"))

                ],
              );
            }
          );
        },
        child: Icon(Icons.add_box, color: Colors.white,),
      ),
    );
  }
}
