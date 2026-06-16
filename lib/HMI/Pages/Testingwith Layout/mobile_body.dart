import 'package:flutter/material.dart';

class MobileBody extends StatelessWidget {
  const MobileBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent[400],
      appBar: AppBar(title: Text('Mobile Screen')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(color: Colors.deepPurple[500]),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(color: Colors.deepPurple[200], height: 120),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
