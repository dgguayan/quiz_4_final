import 'package:flutter/material.dart';
import 'package:quiz_4_final/crud/upload.dart';
import 'package:quiz_4_final/view/listview.dart';
import 'package:quiz_4_final/view/platformlogs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guayan", style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListPDF()));
                }, child: Text("View PDF List"))
              ),
            ),

            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Upload()));
                }, child: Text("Upload PDF"))
              ),
            ),

            Center(
              child: Container(
                child: ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PlatformLogsPage()));
                }, child: Text("Platform Logs"))
              ),
            )
          ],
        ),
      );
    }
}