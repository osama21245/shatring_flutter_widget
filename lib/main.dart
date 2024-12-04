import 'package:custom_paint_practise/destination_card.dart';
import 'package:custom_paint_practise/shattering_widget.dart';
import 'package:flutter/material.dart';

import 'models/destination.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> listItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize the list items once when the widget is created
  }

  @override
  Widget build(BuildContext context) {
    listItems = destinationsList
        .map((destination) => DestinationCard(
              onScatterComplete: () {
                setState(() {
                  destinationsList.remove(destination);
                });
              },
            ))
        .toList();
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: listItems,
      )),
    );
  }
}
