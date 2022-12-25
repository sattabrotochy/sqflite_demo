import 'package:flutter/material.dart';
import 'package:sqlflite_project/userInfo.dart';

import 'database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key });


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? selectedId;
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textController,
        ), // TextField
      ),
      body: Center(
        child: FutureBuilder<List<UserInfoModel>>(
            future: DatabaseHelper.instance.getAllUserList(),
            builder: (BuildContext context,
                AsyncSnapshot<List<UserInfoModel>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                  ? const Center(child: Text('No Groceries in List.'))
                  : ListView(
                children: snapshot.data!.map((userInfo) {
                  return Center(
                    child: Card(
                      color: selectedId == userInfo.id
                          ? Colors.white70
                          : Colors.white,
                      child: ListTile(
                        title: Text(userInfo.name),
                        onLongPress: () {
                          setState(() {
                            DatabaseHelper.instance.remove(userInfo.id!);
                          });
                        },
                        onTap: () {
                          setState(() {
                            textController.text = userInfo.name;
                            selectedId = userInfo.id;
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          selectedId != null
              ? await DatabaseHelper.instance.update(
            UserInfoModel(id: selectedId, name: textController.text),
          )
              : await DatabaseHelper.instance.add(
            UserInfoModel(name: textController.text),
          );
          setState(() {
            textController.clear();
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
