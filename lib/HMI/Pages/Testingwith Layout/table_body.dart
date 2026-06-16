import 'package:flutter/material.dart';

class TableBody extends StatelessWidget {
  const TableBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[500],
      appBar: AppBar(title: Text('Tablet Screen')),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(color: Colors.red[300]),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          color: Colors.deepPurple[200],
                          height: 120,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(height: 150, color: Colors.green[400]),
        ],
      ),
    );
  }
}
