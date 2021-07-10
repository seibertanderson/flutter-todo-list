import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/Item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = <Item>[];
  HomePage() {
    items = [];
    // items.add(Item(title: "Comprar Banana", done: false));
    // items.add(Item(title: "Comprar Abacate", done: true));
    // items.add(Item(title: "Comprar Açucar", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskController = TextEditingController();

  void add() {
    setState(() {
      if (!newTaskController.text.isEmpty) {
        widget.items.add(Item(title: newTaskController.text, done: false));
        newTaskController.text = "";
        save();
      }
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt((index));
      save();
    });
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("data", jsonEncode(widget.items));
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((e) => Item.fromJson(e)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text("Lista de Tarefas"),
        title: TextFormField(
          controller: newTaskController,
          keyboardType: TextInputType.text,
          onChanged: (value) => {print(value)},
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: InputDecoration(
              labelText: "Nova Tarefa",
              labelStyle: TextStyle(color: Colors.white)),
        ),
        actions: <Widget>[],
      ),
      body: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (BuildContext ctx, int index) {
            final item = widget.items[index];

            return Dismissible(
                key: Key(item.title),
                background: Container(
                  color: Colors.red.withOpacity(0.2),
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    print(direction);
                    remove(index);
                  }
                },
                child: CheckboxListTile(
                    title: Text(item.title),
                    value: item.done,
                    onChanged: (value) {
                      print(value);
                      //item.done = value;
                      setState(() {
                        if (value != null) {
                          item.done = value;
                          save();
                        }
                      });
                    }));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
