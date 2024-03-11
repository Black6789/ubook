import 'package:flutter/material.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse('0xFF04305E')),
      body:Column(
        children: [
           SizedBox(height: 20,),
      IconButton(
      color: Color(int.parse('0xFFFBC61A')),
    onPressed: (){
    Navigator.pop(context);
    },
    icon: Icon(Icons.arrow_back),
    )



        ],
      )
    );
  }
}
