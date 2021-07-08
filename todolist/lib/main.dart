import 'package:flutter/material.dart';

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
    items.add(Item(title: "Comprar Banana", done: false));
    items.add(Item(title: "Comprar Abacate", done: true));
    items.add(Item(title: "Comprar Açucar", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        actions: <Widget>[],
      ),
      body: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (BuildContext ctx, int index) {
            final item = widget.items[index];

            return CheckboxListTile(
                title: Text(item.title),
                key: Key(item.title),
                value: item.done,
                onChanged: (value) {
                  print(value);
                  //item.done = value;
                  setState(() {
                    if (value != null) {
                      item.done = value;
                    }
                  });
                });
          }),
    );
  }
}
