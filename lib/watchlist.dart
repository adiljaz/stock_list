import 'package:flutter/material.dart';

class WatchList extends StatelessWidget {
  const WatchList({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(children: [
          Table(
                border: TableBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                children: [
                  TableRow(children: [Text('bjbjhb'), Text('ehbfjh3brhf ')])
                ],
              )



      ],),
    );
  }
}