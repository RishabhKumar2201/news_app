import 'package:flutter/material.dart';
import 'package:news_app/home.dart';

class Empty extends StatefulWidget {
  Empty({super.key});

  @override
  State<Empty> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YOUR NEWS"),
        //centerTitle: true,
      ),
      body: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [

                 Container(
                   margin: EdgeInsets.symmetric(horizontal: 90),
                   child: Text(
                    "Irrelevant Search !",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold),
                ),
                 ),

              ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Text(
                        "< Back",
                        style: TextStyle(fontSize: 18),
                      )
                  ),

            ],
          ),

    );
  }
}
